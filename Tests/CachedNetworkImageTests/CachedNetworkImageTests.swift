import XCTest
@testable import CachedNetworkImage

final class CachedNetworkImageTests: XCTestCase {
    @MainActor
    override func setUp() async throws {
        
    }
    
    @MainActor
    func testCacheHit() async {
        let mockCacheManager = CacheManager(withTimeToLive: 60)
        let testURL = URL(string: "https://example.com/image.jpg")!
        let testImage = UIImage(systemName: "star")!

        mockCacheManager.store(image: testImage, for: testURL)

        // Check that the image is loaded from cache
        let cachedImage = mockCacheManager.image(for: testURL)
        XCTAssertNotNil(cachedImage)
    }
}
