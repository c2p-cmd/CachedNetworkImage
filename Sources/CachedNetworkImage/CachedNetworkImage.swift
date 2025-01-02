//
//  CachedNetworkImage.swift
//  CachedNetworkImage
//
//  Created by Sharan Thakur on 02/01/25.
//

import SwiftUI
import os.log

fileprivate let logger = Logger(subsystem: "com.CachedNetworkImage", category: "CachedNetworkImage")

/// A SwiftUI view for displaying images from the network with caching and placeholder/error handling.
struct CachedNetworkImage<ImageContent: View, PlaceholderContent: View, ErrorContent: View>: View {
    /// The URL of the image to load.
    let url: URL?
    /// A flag indicating whether to keep the image at full resolution.
    let highRes: Bool
    /// The time-to-live for cached images in seconds.
    let cacheTime: TimeInterval
    /// A view builder for rendering the loaded image.
    @ViewBuilder var imageView: (Image) -> ImageContent
    /// A view builder for rendering a placeholder while the image loads.
    @ViewBuilder var placeholder: () -> PlaceholderContent
    /// An optional view builder for rendering an error message if the image fails to load.
    @ViewBuilder var errorView: (Error) -> ErrorContent
    
    /// The cache manager responsible for caching and retrieving images.
    private let cacheManager: CacheManager
    
    /// Initializes a `CachedNetworkImage` view.
    /// - Parameters:
    ///   - url: The URL of the image to load.
    ///   - keepFullRes: Whether to keep the image at full resolution. Defaults to `false`.
    ///   - cacheTime: The time-to-live for cached images in seconds. Defaults to 3600 (1 hour).
    ///   - imageView: A view builder for the loaded image.
    ///   - placeholder: A view builder for the placeholder. Defaults to a `ProgressView`.
    ///   - errorView: An optional view builder for handling errors.
    init(
        url: URL?,
        keepFullRes highRes: Bool = false,
        cacheTime: TimeInterval = 3600,
        imageView: @escaping (Image) -> ImageContent,
        placeholder: @escaping () -> PlaceholderContent = { ProgressView() },
        errorView: @escaping (Error) -> ErrorContent = { error in Text(error.localizedDescription).foregroundStyle(.red) }
    ) {
        self.url = url
        self.highRes = highRes
        self.cacheTime = cacheTime
        self.imageView = imageView
        self.placeholder = placeholder
        self.errorView = errorView
        
        self.cacheManager = CacheManager(withTimeToLive: cacheTime)
    }
    
    @State var result: ImagePhase = .idle
    @State private var imageDownloadTask: Task<Void, Never>? = nil
    
    var body: some View {
        ZStack {
            switch result {
            case .idle:
                placeholder()
            case .success(let image):
                imageView(image)
            case .failure(let error):
                errorView(error)
            }
        }
        .padding()
        .onChange(of: url) { newValue in
            imageDownloadTask?.cancel()
            imageDownloadTask = downloadTask(newUrl: newValue)
        }
        .task(id: url) {
            imageDownloadTask?.cancel()
            imageDownloadTask = downloadTask(newUrl: url)
        }
    }
    
    private func downloadTask(newUrl: URL?) -> Task<Void, Never> {
        Task {
            do {
                if let newUrl {
                    try await validateAndLoadFromCache(from: newUrl)
                } else {
                    result = .idle
                }
            } catch is CancellationError {
              // Do nothing
            } catch {
                result = .failure(error)
                let nsError = error as NSError
                logger.error("\(nsError.domain): \(nsError.localizedDescription)")
            }
        }
    }
    
    /// Validates and loads an image from the cache or fetches it from the network.
    /// - Parameter url: The URL of the image to load.
    func validateAndLoadFromCache(from url: URL) async throws {
        if let cachedImage = cacheManager.image(for: url) {
            logger.info("Image found in cache for URL: \(url)")
            self.result = .success(cachedImage)
        } else {
            logger.info("Image not found in cache for URL: \(url)")
            try await loadImage(from: url)
        }
    }
    
    /// Downloads and processes an image from the specified URL.
    /// - Parameter url: The URL to download the image from.
    func loadImage(from url: URL) async throws {
        try Task.checkCancellation()
        logger.info("Downloading image from URL: \(url)")
        let (data, _) = try await URLSession.shared.data(from: url)
        guard var uiImage = UIImage(data: data) else { throw CachedNetworkImageError.dataNotValidImage }
        
        if highRes == false {
            logger.info("Downsizing image for URL: \(url)")
            uiImage = await ImageDownSizer.downSize(image: uiImage, by: 2)
        }
        cacheManager.store(image: uiImage, for: url)
        
        let image = Image(uiImage: uiImage)
        self.result = .success(image)
    }
}

#Preview {
    ZStack {
        CachedNetworkImage(url: URL(string: "https://plus.unsplash.com/premium_photo-1675621503772-fe697f033522?q=80&w=3270&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")) { img in
            img.resizable()
        } placeholder: {
            Text("loading...")
        } errorView: {
            Text($0.localizedDescription)
                .foregroundStyle(.red)
        }
        .scaledToFit()
        .frame(width: 300)
    }
}
