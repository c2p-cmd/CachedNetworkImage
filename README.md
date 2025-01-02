# CachedNetworkImage

A lightweight, SwiftUI-compatible library for efficiently loading, caching, and displaying images from network URLs. `CachedNetworkImage` helps reduce redundant network requests by caching images and supports customizable placeholders, error handling, and optional resizing for improved performance.

---

## Features

- **Image Caching**: Avoids unnecessary network requests by caching downloaded images.
- **Customizable Placeholders**: Display placeholders while the image is loading.
- **Error Handling**: Define custom views for handling errors.
- **Resizing Options**: Optionally download high-resolution images or resize for performance optimization.
- **Cache Expiration**: Configurable time-to-live (TTL) for cached images.

---

## Installation

### Swift Package Manager

1. In Xcode, go to **File > Add Packages**.
2. Enter the URL of this repository.
3. Select the library and integrate it into your project.

---

## Usage

### Basic Example

```swift
import SwiftUI
import CachedNetworkImage

struct ContentView: View {
    var body: some View {
        CachedNetworkImage(
            url: URL(string: "https://example.com/image.jpg"),
            imageView: { $0.resizable() },
            placeholder: { ProgressView() },
            errorView: { error in Text("Error: \(error.localizedDescription)") }
        )
        .scaledToFit()
        .frame(width: 200, height: 200)
    }
}
```

---

### Parameters

|Parameter | Type | Description |
|----------|------|-------------|
|url       | URL? | URL of image to load |
|highRes   | Bool | Whether to down size image after fetch |
|cacheTime | TimeInterval | The time to live for the cached image. Default is 1 hour|
|imageView | (Image) -> some View | ViewBuilder when image is passed |
|placeholder | () -> some View | ViewBuilder when image is being loaded. Defaults to ProgressView |
|errorView | (any Error) -> some View | ViewBuilder when error occurs |

---

### Advanced Usage

#### Custom Placeholder and Error Views
```swift
CachedNetworkImage(
    url: URL(string: "https://example.com/image.jpg"),
    keepFullRes: false,
    cacheTime: 600, // 10 minutes
    imageView: { $0.resizable().aspectRatio(contentMode: .fit) },
    placeholder: {
        VStack {
            ProgressView()
            Text("Loading image...")
        }
    },
    errorView: { error in
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            Text("Failed to load image")
        }
    }
)
```

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---

## Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a new branch with your feature or bug fix.
3. Submit a pull request with detailed information about your changes
