# Concurrent Videos Control 🎬

Control how many videos can play simultaneously for optimal performance and user experience!

## Overview

The `maxConcurrentVideos` parameter lets you limit how many videos play at the same time. When the limit is reached, the oldest playing video is automatically paused when a new video becomes visible.

## Quick Start

```dart
AxisReelsExploreScreen(
  maxConcurrentVideos: 3,  // Max 3 videos playing at once
)
```

## How It Works

### Default Behavior (2 Concurrent Videos)

```dart
// Default: 2 videos can play simultaneously
AxisReelsExploreScreen()

// Same as:
AxisReelsExploreScreen(maxConcurrentVideos: 2)
```

### Automatic Management

1. **Video becomes visible** → Plays automatically after 800ms delay
2. **Limit reached** → Oldest playing video pauses automatically
3. **Video scrolls out** → Pauses immediately
4. **FIFO queue** → First-In-First-Out (oldest paused first)

### Visual Example

```
Scroll Position    Videos Visible    Playing (max 2)
─────────────────────────────────────────────────
    Top              Video 1          ▶ Video 1
     ↓               Video 2          ▶ Video 2
     ↓               Video 3          ⏸ Video 3 (waiting)
  Scroll Down
     ↓               Video 2          ⏸ Video 2 (paused)
     ↓               Video 3          ▶ Video 3 (playing)
     ↓               Video 4          ▶ Video 4 (playing)
```

## Recommended Values

| Value | Use Case | Performance | UX Quality |
|-------|----------|-------------|------------|
| **1** | Low-end devices | ⚡ Excellent | 😐 Basic |
| **2** | Default (Recommended) | ✅ Great | 😊 Good |
| **3** | Mid-high devices | 👍 Good | 😃 Better |
| **4** | High-end devices | 💪 Fair | 🤩 Great |
| **5** | Premium devices only | ⚠️ Heavy | 🔥 Best |
| **null** | Unlimited (Not recommended) | ❌ Poor | 🎯 Variable |

## Usage Examples

### 1. Conservative (Best Performance)

```dart
AxisReelsExploreScreen(
  maxConcurrentVideos: 1,  // Only 1 video plays at a time
)
```

**Best for:**
- Low-end devices
- Poor network conditions
- Battery saving
- Reducing data usage

### 2. Balanced (Recommended Default)

```dart
AxisReelsExploreScreen(
  maxConcurrentVideos: 2,  // Default - good balance
)
```

**Best for:**
- Most use cases
- General audience
- Good UX + performance balance

### 3. Premium Experience

```dart
AxisReelsExploreScreen(
  maxConcurrentVideos: 3,  // Premium experience
)
```

**Best for:**
- High-end devices
- Fast networks
- Premium user segment
- Smooth scrolling experience

### 4. Maximum Videos

```dart
AxisReelsExploreScreen(
  maxConcurrentVideos: 5,  // Many videos at once
)
```

**Best for:**
- Flagship devices only
- WiFi connections
- Desktop/tablet
- Showcase/demo purposes

### 5. Unlimited (Use Carefully!)

```dart
AxisReelsExploreScreen(
  maxConcurrentVideos: null,  // No limit (not recommended)
)
```

**⚠️ Warning:**
- Can cause performance issues
- High memory usage
- Battery drain
- Not recommended for production

## Dynamic Adjustment

Adjust based on device capabilities or user settings:

```dart
class VideoGridScreen extends StatefulWidget {
  @override
  State<VideoGridScreen> createState() => _VideoGridScreenState();
}

class _VideoGridScreenState extends State<VideoGridScreen> {
  int _maxConcurrentVideos = 2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Control slider
        Slider(
          value: _maxConcurrentVideos.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          label: 'Max: $_maxConcurrentVideos',
          onChanged: (value) {
            setState(() {
              _maxConcurrentVideos = value.toInt();
            });
          },
        ),

        // Grid with dynamic limit
        Expanded(
          child: AxisReelsExploreScreen(
            key: ValueKey(_maxConcurrentVideos), // Rebuild when changed
            maxConcurrentVideos: _maxConcurrentVideos,
          ),
        ),
      ],
    );
  }
}
```

## Device-Based Auto Configuration

```dart
int getOptimalConcurrentVideos() {
  // Check device capabilities
  final platformInfo = /* get device info */;

  if (platformInfo.isLowEnd) {
    return 1;  // Conservative
  } else if (platformInfo.isMidRange) {
    return 2;  // Balanced (default)
  } else if (platformInfo.isHighEnd) {
    return 3;  // Premium
  } else {
    return 4;  // Flagship
  }
}

AxisReelsExploreScreen(
  maxConcurrentVideos: getOptimalConcurrentVideos(),
)
```

## Network-Based Adjustment

```dart
int getConcurrentVideosForNetwork(String connectionType) {
  switch (connectionType) {
    case 'wifi':
      return 3;  // More videos on WiFi
    case '4g':
    case '5g':
      return 2;  // Moderate on cellular
    case '3g':
      return 1;  // Conservative on slow networks
    default:
      return 2;  // Default
  }
}
```

## Performance Impact

### Memory Usage

| Concurrent Videos | Est. Memory | Notes |
|------------------|-------------|-------|
| 1 | ~50 MB | Minimal |
| 2 | ~100 MB | Good |
| 3 | ~150 MB | Moderate |
| 4 | ~200 MB | High |
| 5+ | ~250+ MB | Very High |

*Estimates vary based on video quality and resolution*

### CPU Usage

| Concurrent Videos | CPU Load | Battery Impact |
|------------------|----------|----------------|
| 1 | Low | Minimal |
| 2 | Moderate | Low |
| 3 | Medium | Moderate |
| 4 | High | Significant |
| 5+ | Very High | Heavy |

## Best Practices

### ✅ Do's

1. **Start Conservative** - Use default (2) or lower initially
2. **Test on Real Devices** - Verify performance on target devices
3. **Consider Network** - Adjust based on connection quality
4. **Monitor Performance** - Check memory and CPU usage
5. **User Settings** - Let users choose their preference

### ❌ Don'ts

1. **Don't Use Unlimited** - Always set a reasonable limit
2. **Don't Ignore Performance** - Monitor device capabilities
3. **Don't Forget Mobile Data** - High limits drain data quickly
4. **Don't One-Size-Fits-All** - Adjust for different scenarios

## Troubleshooting

### Videos Not Playing

**Problem:** No videos play automatically

**Solutions:**
1. Check `maxConcurrentVideos` is > 0
2. Verify videos are visible (90%+ in viewport)
3. Check autoplay delay (800ms default)

### Performance Issues

**Problem:** App lags or stutters

**Solutions:**
1. Reduce `maxConcurrentVideos` (try 1 or 2)
2. Check device capabilities
3. Reduce video quality/resolution
4. Check network bandwidth

### Memory Warnings

**Problem:** App receives memory warnings

**Solutions:**
1. Lower `maxConcurrentVideos` to 1-2
2. Implement device-based auto-adjustment
3. Clear cache periodically
4. Reduce video quality

## Advanced: Custom Implementation

If you need more control, you can use the provider directly:

```dart
// Advanced usage with provider
final state = ref.watch(axisReelsProvider(AxisReelsProviderParams(
  reels: myCustomReels,
  maxConcurrentVideos: 3,
)));
```

## Complete Example

See the full working example:
- [concurrent_videos_example.dart](example/lib/concurrent_videos_example.dart)

Run it:
```bash
cd example
flutter run
# Then tap "Concurrent Videos" button
```

## FAQ

**Q: What's the default value?**
A: 2 videos - good balance between UX and performance

**Q: Can I set it to 0?**
A: No, minimum is 1. Use 1 if you want conservative playback.

**Q: What happens with unlimited (null)?**
A: Not recommended - all visible videos play, causing performance issues.

**Q: Does it affect images?**
A: No, only videos. Images always display regardless of this setting.

**Q: Can I change it dynamically?**
A: Yes! Use `setState` and `ValueKey` to rebuild with new value.

**Q: How do I know what's optimal for my app?**
A: Test on target devices, start with 2, adjust based on performance metrics.

## See Also

- [FEATURES.md](FEATURES.md) - All features documentation
- [DEFAULT_CHANGES.md](DEFAULT_CHANGES.md) - Default configuration guide
- [Example App](example/) - Working examples
