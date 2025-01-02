//
//  CacheManager.swift
//  CachedNetworkImage
//
//  Created by Sharan Thakur on 02/01/25.
//

import SwiftUI

/// A class that manages an in-memory cache for storing and retrieving images with expiration functionality.
class CacheManager {
    
    /// A wrapper class to store a `UIImage` along with its expiration date.
    class CachedImage {
        let uiImage: UIImage
        let date: Date
        
        /// Initializes a cached image object.
        /// - Parameters:
        ///   - uiImage: The `UIImage` to cache.
        ///   - date: The expiration date for the cached image. Defaults to the current date and time.
        init(_ uiImage: UIImage, withExpiration date: Date = .now) {
            self.uiImage = uiImage
            self.date = date
        }
    }
    
    /// The time interval (in seconds) for which cached images remain valid.
    let timeToLive: TimeInterval
    
    /// Initializes a cache manager with a specified time-to-live for cached images.
    /// - Parameter timeToLive: The time interval in seconds after which cached images expire.
    init(withTimeToLive timeToLive: TimeInterval) {
        self.timeToLive = timeToLive
    }
    
    /// The underlying cache storage using `NSCache` for efficient in-memory caching.
    private let cache = NSCache<NSString, CachedImage>()
    
    /// Retrieves a cached image for a given URL key if it exists and has not expired.
    /// - Parameter key: The `URL` key associated with the cached image.
    /// - Returns: An optional `Image` if the image exists and is valid, or `nil` if not found or expired.
    func image(for key: URL) -> Image? {
        let key = key.absoluteString as NSString
        
        // Retrieve the cached image object
        guard let cachedImage = cache.object(forKey: key) else { return nil }
        
        // Check if the cached image has expired
        if Date.now > cachedImage.date {
            cache.removeObject(forKey: key) // Remove expired image
            return nil
        }
        
        // Return the image if still valid
        return Image(uiImage: cachedImage.uiImage)
    }
    
    /// Stores a `UIImage` in the cache with a specified key and expiration time.
    /// - Parameters:
    ///   - image: The `UIImage` to cache.
    ///   - key: The `URL` key to associate with the image.
    func store(image: UIImage, for key: URL) {
        let key = key.absoluteString as NSString
        
        // Compute the expiration date for the image
        let expirationDate = Date().addingTimeInterval(timeToLive)
        
        // Create a cached image object and store it in the cache
        let value = CachedImage(image, withExpiration: expirationDate)
        cache.setObject(value, forKey: key)
    }
}
