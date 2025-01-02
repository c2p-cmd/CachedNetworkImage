//
//  CachedNetworkImageError.swift
//  CachedNetworkImage
//
//  Created by Sharan Thakur on 02/01/25.
//

import SwiftUI

/// Errors that can occur while fetching image from network
/// - `invalidURL`: Invalid URL
/// - `dataNotValidImage`: Data is not a valid image
enum CachedNetworkImageError: LocalizedError, CustomStringConvertible {
    case invalidURL
    case dataNotValidImage
    
    /// Localized description of error
    var errorDescription: String? { description }
    
    /// Textual representation of error
    var description: String {
        switch self {
        case .invalidURL:
            "Imavlid URL"
        case .dataNotValidImage:
            "Data is not a valid image"
        }
    }
}
