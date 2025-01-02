//
//  ImagePhase.swift
//  CachedNetworkImage
//
//  Created by Sharan Thakur on 02/01/25.
//

import SwiftUI

/// Phase of ``CachedNetworkImage`` while fetching image from network
enum ImagePhase: CustomDebugStringConvertible, Equatable {
    case idle
    case success(Image)
    case failure(Error)
    
    var debugDescription: String {
        switch self {
        case .idle:
            "Idle"
        case .success(let image):
            "Success: \(image)"
        case .failure(let error):
            "Failure: \(error)"
        }
    }
    
    static func == (lhs: ImagePhase, rhs: ImagePhase) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            true
        case (.success(let image), .success(let image2)):
            image == image2
        case (.failure(let e1), .failure(let e2)):
            e1.localizedDescription == e2.localizedDescription
        default:
            false
        }
    }
}
