# DraggableScrollableSheet Integration Guide

## Overview

The `AxisReelsExploreScreen` now supports seamless scroll coordination with `DraggableScrollableSheet`. When you reach the edge of the grid content, scrolling automatically continues to expand or collapse the sheet - no dual scroll behavior!

## How It Works

### The Problem
Without proper coordination:
- Scrolling the grid and scrolling the sheet feel like two separate gestures
- User has to "lift and scroll again" when reaching the grid edge
- Jarring user experience

### The Solution
Using `shrinkWrap: true`:
- When scrolling **up** at the **top** of grid → sheet **collapses**
- When scrolling **down** at the **bottom** of grid → sheet **expands**
- In the **middle** of grid → **normal scrolling**
- Seamless unified scrolling experience!

## Implementation

### Step 1: Basic Setup

```dart
DraggableScrollableSheet(
  initialChildSize: 0.4,
  minChildSize: 0.2,
  maxChildSize: 0.95,
  builder: (context, scrollController) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Your header/handle bar here

          // Video grid with coordination
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController, // ← Pass sheet's controller
              child: ProviderScope(
                child: AxisReelsExploreScreen(
                  shrinkWrap: true, // ← CRITICAL: Enables coordination
                  showAppBar: false,
                  backgroundColor: Colors.transparent,
                  // ... other parameters
                ),
              ),
            ),
          ),
        ],
      ),
    );
  },
)
```

### Step 2: Key Parameters

| Parameter | Value | Why |
|-----------|-------|-----|
| `shrinkWrap` | `true` | Allows grid to size itself based on content, enabling scroll coordination |
| `showAppBar` | `false` | No scaffold wrapper - we're embedding in sheet |
| `manageScroll` | `true` | Grid manages its own ListView (wrapped in SingleChildScrollView) |

## Complete Example

See `example/lib/draggable_sheet_example.dart` for a full working implementation.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_awsome_video_grid/flutter_awsome_video_grid.dart';

class MyDraggableSheetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background content
          Container(color: Colors.black),

          // Draggable sheet with video grid
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Handle bar
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Video grid
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: ProviderScope(
                          child: AxisReelsExploreScreen(
                            shrinkWrap: true, // ← Key parameter
                            showAppBar: false,
                            backgroundColor: Colors.transparent,
                            showMediaTypeIcon: true,
                            maxConcurrentVideos: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

## Technical Details

### Architecture

1. **SingleChildScrollView** receives the sheet's `scrollController`
2. **AxisReelsExploreScreen** with `shrinkWrap: true` sizes to its content
3. **ListView.builder** inside uses `shrinkWrap: true` internally
4. Sheet's controller handles all scroll events
5. When grid edges are reached, momentum continues to sheet

### Performance Considerations

- `shrinkWrap: true` has a performance cost - it measures all children
- Best for lists with known/limited content (30-50 items)
- If you have 100+ items, consider using `manageScroll: false` with a different approach

### Alternative Approach (for very long lists)

For lists with 100+ items where shrinkWrap might impact performance:

```dart
DraggableScrollableSheet(
  builder: (context, scrollController) {
    return AxisReelsExploreScreen(
      scrollController: scrollController, // Direct controller
      shrinkWrap: false, // No shrinkWrap
      showAppBar: false,
      physics: AlwaysScrollableScrollPhysics(), // Explicit physics
    );
  },
)
```

This won't have the seamless edge transition, but will perform better with large lists.

## Testing the Behavior

1. **Start**: Sheet at `initialChildSize` (e.g., 40%)
2. **Scroll down in grid**: Grid scrolls normally
3. **Reach bottom of grid**: Continue scrolling → sheet expands to `maxChildSize`
4. **Scroll up in grid**: Grid scrolls normally
5. **Reach top of grid**: Continue scrolling → sheet collapses to `minChildSize`

## Common Issues

### Issue: Dual scroll behavior still present
**Solution**: Make sure you're wrapping the grid in `SingleChildScrollView` with the sheet's controller

### Issue: Grid doesn't scroll at all
**Solution**: Verify `manageScroll: true` and `shrinkWrap: true` are both set

### Issue: Performance issues with large lists
**Solution**: Use the alternative approach without shrinkWrap for 100+ items

## API Reference

### New Parameter: `shrinkWrap`

```dart
/// Whether the ListView should shrinkWrap its content
/// Set to true when using with DraggableScrollableSheet for seamless scroll coordination
/// When true, scrolling continues from grid content to sheet at edges
/// Default: false
final bool shrinkWrap;
```

**Usage**:
```dart
AxisReelsExploreScreen(
  shrinkWrap: true, // Enable seamless sheet coordination
)
```

## See Also

- `example/lib/draggable_sheet_example.dart` - Full working example
- `FEATURES.md` - Complete feature documentation
- Flutter's [DraggableScrollableSheet documentation](https://api.flutter.dev/flutter/widgets/DraggableScrollableSheet-class.html)
