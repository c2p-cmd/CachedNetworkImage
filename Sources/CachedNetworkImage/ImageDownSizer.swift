//
//  ImageDownSizer.swift
//  CachedNetworkImage
//
//  Created by Sharan Thakur on 02/01/25.
//

import SwiftUI

/// A utility class for resizing images while maintaining their aspect ratio.
internal class ImageDownSizer {
    /// Downsizes a given image to a smaller size based on the specified scale.
    /// - Parameters:
    ///   - image: The `UIImage` to be downsized.
    ///   - scale: A `CGFloat` value representing the scale factor for resizing. The image's dimensions are divided by this scale.
    /// - Returns: A downsized `UIImage` that maintains the original aspect ratio.
    class func downSize(image: UIImage, by scale: CGFloat) async -> UIImage {
        let currentSize = image.size
        let sizeToFit = currentSize / scale
        let aspectSize = currentSize.aspectFit(to: sizeToFit)
        
        let task = Task.detached(priority: .high) {
            let renderer = UIGraphicsImageRenderer(size: aspectSize)
            
            return renderer.image { ctx in
                image.draw(in: CGRect(origin: .zero, size: aspectSize))
            }
        }
        
        return await task.result.get()
    }
}

fileprivate extension CGSize {
    /// This function will return a size that fits the current size to the given size while maintaining the aspect ratio
    /// - Parameter size: The size to fit the current size to
    /// - Returns: The size that fits the current size to the given size while maintaining the aspect ratio
    func aspectFit(to size: CGSize) -> CGSize {
        let scaleX = size.width / width
        let scaleY = size.height / height
        
        let aspectRatio = min(scaleX, scaleY)
        
        return CGSize(width: width * aspectRatio, height: height * aspectRatio)
    }
    
    /// Reduces a `CGSize` by dividing its dimensions by a given scale.
    /// - Parameters:
    ///   - lhs: The original `CGSize`.
    ///   - rhs: The scale factor to divide the dimensions by.
    /// - Returns: A new `CGSize` with the dimensions scaled down.
    static func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
    }
}
