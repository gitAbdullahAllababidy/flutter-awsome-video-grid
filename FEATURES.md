# Flutter Awesome Video Grid - Advanced Features Guide

## Overview

This package provides a highly customizable video and image grid with advanced features for complex UI scenarios.

## 🎨 Custom Foreground & Background Builders

### Foreground Builder

Create custom overlays for each grid item with full control over the UI.

```dart
AxisReelsExploreScreen(
  foregroundBuilder: (context, reel, isVideoPlaying) {
    return Stack(
      children: [
        // Top badge
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: reel.type == ReelType.video ? Colors.red : Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(reel.type == ReelType.video ? 'VIDEO' : 'IMAGE'),
          ),
        ),
        // Playing indicator
        if (isVideoPlaying)
          Positioned(
            top: 8,
            right: 8,
            child: Icon(Icons.play_circle_filled, color: Colors.green),
          ),
        // Custom title overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(12),
            color: Colors.black.withValues(alpha: 0.7),
            child: Text(
              reel.title ?? '',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  },
)
```

**Parameters:**
- `context`: BuildContext for theme access
- `reel`: AxisReelModel with item data
- `isVideoPlaying`: Boolean indicating video playback state

### Background Builder

Add custom gradients, patterns, or effects behind each item.

```dart
AxisReelsExploreScreen(
  backgroundBuilder: (context, reel) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            reel.type == ReelType.video
              ? Colors.purple.withValues(alpha: 0.3)
              : Colors.blue.withValues(alpha: 0.3),
          ],
        ),
      ),
    );
  },
)
```

**Parameters:**
- `context`: BuildContext for theme access
- `reel`: AxisReelModel with item data

## 🎯 Scroll Behavior Control

### Embedded in Custom Scroll Views

Use `manageScroll: false` to embed the grid in complex scrollable widgets like `CustomScrollView`.

```dart
CustomScrollView(
  slivers: [
    SliverAppBar(/* ... */),

    SliverToBoxAdapter(
      child: AxisReelsExploreScreen(
        showAppBar: false,        // No internal scaffold
        manageScroll: false,      // External scroll management
        padding: EdgeInsets.all(8),
      ),
    ),

    SliverList(/* ... */),
  ],
)
```

### External Scroll Controller

Provide your own scroll controller for advanced scroll coordination.

```dart
final scrollController = ScrollController();

AxisReelsExploreScreen(
  manageScroll: true,           // Still manages scroll
  scrollController: scrollController,  // But uses your controller
)
```

### Standalone Scrollable Grid (Default)

```dart
AxisReelsExploreScreen(
  manageScroll: true,   // Default: creates own scroll controller
)
```

## 🎬 Media Type Auto-Detection

Media type is automatically detected from URL extensions - no need to specify manually!

```dart
final myReels = [
  AxisReelModel.fromUrl(
    id: '1',
    url: 'https://example.com/photo.jpg',  // ← Auto-detected as image
    title: 'Beach Photo',
  ),
  AxisReelModel.fromUrl(
    id: '2',
    url: 'https://example.com/clip.mp4',   // ← Auto-detected as video
    title: 'Surfing Video',
    loopCount: 5,
  ),
];

AxisReelsExploreScreen(reels: myReels)
```

**Supported video extensions:** `.mp4`, `.mov`, `.avi`, `.mkv`, `.webm`

## 📦 Image Caching Strategy

Images use an optimized caching strategy that shows old cache while checking for updates.

**Built-in cache configuration:**
- Disk cache: 1000x1000px max
- Memory cache: 1000x1000px max
- Cache key: URL-based for consistency
- Shows cached image immediately while validating

**No additional setup required** - just use the widget!

## 🎬 Concurrent Videos Control

Control how many videos play simultaneously for optimal performance!

```dart
AxisReelsExploreScreen(
  maxConcurrentVideos: 3,  // Max 3 videos playing at once (default: 2)
)
```

**Recommended values:**
- `1` - Low-end devices, best performance
- `2` - **Default** - Good balance (recommended)
- `3` - High-end devices, smooth experience
- `4-5` - Premium devices only
- `null` - Unlimited (not recommended)

**How it works:**
- When limit reached, oldest playing video pauses automatically
- FIFO queue (First-In-First-Out)
- Automatic management based on visibility

See [CONCURRENT_VIDEOS.md](CONCURRENT_VIDEOS.md) for detailed guide.

## ⚙️ Configuration Options

### UI Customization

```dart
AxisReelsExploreScreen(
  // AppBar control
  showAppBar: true,              // Show/hide scaffold & app bar
  title: 'My Gallery',           // Optional app bar title

  // Visual options
  showVideoIndicator: false,     // Play icon badge (default: false)
  showPlayButton: true,          // Pause/play overlay (default: true)
  backgroundColor: Colors.grey[900],

  // Performance
  maxConcurrentVideos: 2,        // Max videos playing at once

  // Layout
  padding: EdgeInsets.all(16),
  itemSpacing: 12.0,             // Space between items
)
```

### Default Values

| Parameter | Default | Description |
|-----------|---------|-------------|
| `showAppBar` | `false` | Shows Scaffold with AppBar |
| `manageScroll` | `true` | Creates internal scroll controller |
| `showVideoIndicator` | `false` | Top-right video play icon |
| `showPlayButton` | `true` | Center play/pause button |
| `maxConcurrentVideos` | `2` | Max videos playing simultaneously |
| `padding` | `EdgeInsets.all(8)` | Grid padding |
| `itemSpacing` | `8.0` | Gap between items |
| `backgroundColor` | `Colors.transparent` | Background color |

## 🎯 Complete Example

### Minimal Setup (Just the Grid!)

```dart
// Default: Just the grid with transparent background
// Perfect for embedding in your own layout
AxisReelsExploreScreen()
```

### With AppBar and Background

```dart
// Add Scaffold wrapper with AppBar and background
AxisReelsExploreScreen(
  showAppBar: true,
  title: 'My Gallery',
  backgroundColor: Colors.black,
)
```

### Custom Data with Auto-Detection

```dart
final customReels = [
  AxisReelModel.fromUrl(
    id: '1',
    url: 'https://picsum.photos/800',
    title: 'Random Image',
  ),
  AxisReelModel.fromUrl(
    id: '2',
    url: 'https://example.com/video.mp4',
    title: 'Sample Video',
    thumbnailUrl: 'https://picsum.photos/801',
    loopCount: 3,
  ),
];

AxisReelsExploreScreen(
  reels: customReels,
  title: 'My Custom Gallery',
)
```

### Full Customization

```dart
AxisReelsExploreScreen(
  reels: customReels,

  // Custom builders
  foregroundBuilder: (context, reel, isPlaying) => MyCustomOverlay(reel, isPlaying),
  backgroundBuilder: (context, reel) => MyCustomBackground(reel),

  // Scroll control
  showAppBar: false,
  manageScroll: false,

  // UI options
  showVideoIndicator: true,
  showPlayButton: true,
  backgroundColor: Colors.grey[900],
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  itemSpacing: 12.0,
)
```

## 📱 Usage Scenarios

### 1. Standalone Gallery
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AxisReelsExploreScreen(
      showAppBar: true,      // Enable AppBar
      title: 'My Gallery',
      backgroundColor: Colors.black,
    ),
  ),
);
```

### 2. Embedded in Tab View
```dart
TabBarView(
  children: [
    AxisReelsExploreScreen(),  // Default: no AppBar, perfect for tabs
    OtherTabContent(),
  ],
)
```

### 3. Part of Complex Layout
```dart
Column(
  children: [
    MyHeader(),
    Expanded(
      child: AxisReelsExploreScreen(), // Default: transparent & no scaffold
    ),
  ],
)
```

### 4. Nested in CustomScrollView
```dart
CustomScrollView(
  slivers: [
    SliverAppBar(/* ... */),
    SliverToBoxAdapter(
      child: AxisReelsExploreScreen(
        manageScroll: false,  // showAppBar already false by default
        backgroundColor: Colors.black,
      ),
    ),
  ],
)
```

## 🔧 Migration from Previous Version

### Old API (Deprecated)
```dart
// Old: Manual type specification
const AxisReelModel(
  id: '1',
  url: 'https://example.com/video.mp4',
  type: ReelType.video,  // ❌ No longer needed
  title: 'Video',
)

// Old: Row-based data structure
DefaultReelsData.rows  // ❌ Deprecated
```

### New API (Recommended)
```dart
// New: Auto-detection
AxisReelModel.fromUrl(
  id: '1',
  url: 'https://example.com/video.mp4',  // ✅ Type detected automatically
  title: 'Video',
)

// New: Flat list structure
DefaultReelsData.flatList  // ✅ Recommended
```

## 🚀 Performance Tips

1. **Use auto-detection**: `AxisReelModel.fromUrl()` is optimized
2. **Leverage caching**: Images/thumbnails cache automatically
3. **External scroll**: Use `manageScroll: false` in nested scenarios
4. **Custom builders**: Keep builder logic lightweight for smooth scrolling
5. **Thumbnail URLs**: Provide thumbnails for videos to improve perceived performance

## 📚 See Also

- [Main README](README.md) - Installation and basic usage
- [Example App](example/) - Complete working examples
- [API Documentation](lib/) - Full API reference
