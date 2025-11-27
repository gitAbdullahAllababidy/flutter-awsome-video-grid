# Flutter Awesome Video Grid 🎬

A powerful Flutter package for displaying Instagram/TikTok-style reels in a grid layout with intelligent video playback management, custom UI builders, and performance optimization.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.10%2B-blue.svg)](https://flutter.dev)

## ✨ Features

- 🎬 **Concurrent Video Control** - Limit simultaneous playing videos (1-5) for optimal performance
- 🎨 **Custom Builders** - Build custom foreground overlays and backgrounds
- 📜 **Flexible Scrolling** - Embed in any scrollable widget (CustomScrollView, TabView, etc.)
- 🚀 **Auto Media Detection** - Automatically detects image/video from URL extension
- 💾 **Smart Caching** - Optimized image and video caching with old cache fallback
- 🎯 **Visibility Management** - Auto play/pause based on 90% visibility
- ⚡ **Performance Optimized** - Efficient resource management and memory usage
- 🔄 **Automatic Row Layout** - Pass flat list, get 2-column grid automatically
- 🎭 **Highly Customizable** - Control every aspect of UI and behavior
- 🔇 **Muted by Default** - Videos start muted for better UX
- 🎮 **Finite Video Looping** - Configurable loop count per video

## 📸 Screenshots

| Grid View | Custom Foreground | Concurrent Control |
|-----------|------------------|-------------------|
| ![Grid](https://via.placeholder.com/250x450?text=Grid+View) | ![Custom](https://via.placeholder.com/250x450?text=Custom+UI) | ![Control](https://via.placeholder.com/250x450?text=Performance) |

## 🚀 Installation

### Option 1: From Git Repository

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_awsome_video_grid:
    git:
      url: https://github.com/yourusername/flutter_awsome_video_grid.git
      ref: main
```

### Option 2: Local Path

For local development:

```yaml
dependencies:
  flutter_awsome_video_grid:
    path: ../flutter_awsome_video_grid
```

Then run:

```bash
flutter pub get
```

## 📖 Quick Start

### 1. Wrap your app with ProviderScope

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### 2. Use the widget

```dart
import 'package:flutter_awsome_video_grid/flutter_awsome_video_grid.dart';

// Simple usage - just the grid!
AxisReelsExploreScreen()
```

That's it! The widget comes with:
- ✅ Default sample data
- ✅ Transparent background
- ✅ Smart defaults
- ✅ Auto media type detection

## 📚 Usage Examples

### Basic - Just the Grid

```dart
// Minimal - transparent background, embeddable anywhere
AxisReelsExploreScreen()
```

### With AppBar and Background

```dart
AxisReelsExploreScreen(
  showAppBar: true,
  title: 'My Gallery',
  backgroundColor: Colors.black,
)
```

### Custom Data with Auto-Detection

```dart
final myReels = [
  AxisReelModel.fromUrl(
    id: '1',
    url: 'https://example.com/photo.jpg',  // ← Auto-detected as image
    title: 'Beautiful Photo',
  ),
  AxisReelModel.fromUrl(
    id: '2',
    url: 'https://example.com/video.mp4',  // ← Auto-detected as video
    title: 'Cool Video',
    thumbnailUrl: 'https://example.com/thumb.jpg',
    loopCount: 5,
  ),
];

AxisReelsExploreScreen(reels: myReels)
```

### Control Concurrent Videos (NEW!)

```dart
// Conservative - best performance
AxisReelsExploreScreen(maxConcurrentVideos: 1)

// Balanced - recommended (default)
AxisReelsExploreScreen(maxConcurrentVideos: 2)

// Premium - high-end devices
AxisReelsExploreScreen(maxConcurrentVideos: 3)
```

### Custom Foreground Builder (NEW!)

```dart
AxisReelsExploreScreen(
  foregroundBuilder: (context, reel, isPlaying) {
    return Stack(
      children: [
        // Top badge
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              reel.title ?? '',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        // Playing indicator
        if (isPlaying)
          Positioned(
            top: 8,
            right: 8,
            child: Icon(Icons.play_circle, color: Colors.green),
          ),
      ],
    );
  },
)
```

### Embed in CustomScrollView (NEW!)

```dart
CustomScrollView(
  slivers: [
    SliverAppBar(
      title: Text('My App'),
    ),
    SliverToBoxAdapter(
      child: AxisReelsExploreScreen(
        manageScroll: false,  // External scroll management
        backgroundColor: Colors.black,
      ),
    ),
  ],
)
```

## ⚙️ Configuration Options

### All Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `reels` | `List<AxisReelModel>?` | `null` | Custom reels (null = default data) |
| `title` | `String?` | `null` | AppBar title |
| `foregroundBuilder` | `ItemForegroundBuilder?` | `null` | Custom foreground overlay |
| `backgroundBuilder` | `ItemBackgroundBuilder?` | `null` | Custom background |
| `showAppBar` | `bool` | `false` | Show Scaffold with AppBar |
| `manageScroll` | `bool` | `true` | Internal scroll management |
| `scrollController` | `ScrollController?` | `null` | External scroll controller |
| `showVideoIndicator` | `bool` | `false` | Top-right play icon |
| `showPlayButton` | `bool` | `true` | Center play/pause button |
| `maxConcurrentVideos` | `int?` | `2` | Max videos playing at once |
| `padding` | `EdgeInsets?` | `EdgeInsets.all(8)` | Grid padding |
| `itemSpacing` | `double` | `8.0` | Space between items |
| `backgroundColor` | `Color?` | `Colors.transparent` | Background color |

## 🎬 Advanced Features

### 1. Concurrent Videos Control

Optimize performance by limiting simultaneous video playback:

```dart
AxisReelsExploreScreen(
  maxConcurrentVideos: 3,  // Max 3 videos playing at once
)
```

**How it works:**
- When limit is reached, oldest playing video pauses automatically
- FIFO queue (First-In-First-Out)
- Smooth transitions

**Recommended values:**
- `1` - Low-end devices
- `2` - Balanced (default)
- `3` - High-end devices
- `4-5` - Premium devices only

📖 [Complete Guide](CONCURRENT_VIDEOS.md)

### 2. Custom UI Builders

Build completely custom overlays and backgrounds:

```dart
AxisReelsExploreScreen(
  foregroundBuilder: (context, reel, isPlaying) {
    // Your custom overlay with access to playing state
    return YourCustomOverlay();
  },
  backgroundBuilder: (context, reel) {
    // Your custom background/gradient
    return YourCustomBackground();
  },
)
```

### 3. Flexible Scroll Management

Perfect for complex UIs:

```dart
// Embed in tabs
TabBarView(
  children: [
    AxisReelsExploreScreen(),  // Works out of the box
  ],
)

// Embed in nested scroll
CustomScrollView(
  slivers: [
    SliverToBoxAdapter(
      child: AxisReelsExploreScreen(
        manageScroll: false,
      ),
    ),
  ],
)
```

## 📦 Model Classes

### AxisReelModel

```dart
// Auto-detect media type from URL
AxisReelModel.fromUrl(
  id: 'unique_id',
  url: 'https://example.com/video.mp4',  // .mp4, .mov, .avi, .mkv, .webm = video
  thumbnailUrl: 'https://example.com/thumb.jpg',
  title: 'My Video',
  description: 'Optional description',
  loopCount: 5,
)

// Or specify manually
const AxisReelModel(
  id: 'unique_id',
  url: 'https://example.com/video.mp4',
  type: ReelType.video,
  thumbnailUrl: 'https://example.com/thumb.jpg',
  title: 'My Video',
  loopCount: 3,
)
```

### DefaultReelsData

```dart
// Get default sample data (30 items)
final reels = DefaultReelsData.flatList;

// Create custom grid from flat list
final grid = DefaultReelsData.createCustomGrid(
  items: myReels,
);
```

## 🎯 Use Cases

- 📱 Social media apps (Instagram, TikTok-style grids)
- 🎥 Video galleries and portfolios
- 🛍️ Product showcases with videos
- 🎨 Creative content libraries
- 📰 Media-rich news feeds
- 🏪 E-commerce product catalogs

## 📱 Platform Support

| Platform | Status |
|----------|--------|
| Android | ✅ Tested |
| iOS | ✅ Tested |
| Web | ✅ Supported |
| Windows | ✅ Supported |
| macOS | ✅ Supported |
| Linux | ✅ Supported |

## 🔧 Requirements

- Flutter SDK: `>=3.10.0`
- Dart SDK: `>=3.8.1`

## 📚 Documentation

- [FEATURES.md](FEATURES.md) - Complete features guide with examples
- [CONCURRENT_VIDEOS.md](CONCURRENT_VIDEOS.md) - Concurrent videos performance guide
- [DEFAULT_CHANGES.md](DEFAULT_CHANGES.md) - Default configuration guide
- [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md) - Complete changelog
- [Example App](example/) - Full working examples

## 🏃 Run Examples

```bash
cd example
flutter run
```

The example app includes:
- ✅ Default data demo
- ✅ Custom foreground builders
- ✅ Nested scroll scenarios
- ✅ Concurrent videos control with slider
- ✅ Interactive configuration

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with Flutter and Riverpod
- Inspired by Instagram and TikTok grid layouts
- Uses cached_video_player_plus for optimal video performance

## 💡 Tips

1. **Image Optimization** - Use properly sized images for better performance
2. **Video Quality** - Keep videos reasonable size for faster loading
3. **Concurrent Videos** - Start with 2, adjust based on device capabilities
4. **Custom Builders** - Keep builder logic lightweight for smooth scrolling
5. **Caching** - Package handles caching automatically - just provide URLs!

## 📧 Support

If you have any questions or issues:
- 📫 Open an issue on GitHub
- 📚 Check the [documentation](FEATURES.md)
- 💬 See the [example app](example/)

## ⭐ Show Your Support

Give a ⭐ if this project helped you!

---

**Made with Flutter** 💙 **and** ❤️
