import 'package:flutter/material.dart';
import 'package:flutter_awsome_video_grid/flutter_awsome_video_grid.dart';

/// Example demonstrating custom foreground and background builders
class CustomForegroundExample extends StatelessWidget {
  const CustomForegroundExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Custom Foreground Example',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: AxisReelsExploreScreen(
        showAppBar: false, // We're providing our own AppBar
        showVideoIndicator: false, // Clean look without video indicator
        backgroundColor: Colors.black,
        foregroundBuilder: _buildCustomForeground,
        backgroundBuilder: _buildCustomBackground,
      ),
    );
  }

  /// Custom foreground builder with beautiful gradient and play indicator
  Widget _buildCustomForeground(
    BuildContext context,
    AxisReelModel reel,
    bool isVideoPlaying,
  ) {
    return Stack(
      children: [
        // Top badge for media type
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: reel.type == ReelType.video
                  ? Colors.red.withValues(alpha: 0.8)
                  : Colors.blue.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  reel.type == ReelType.video ? Icons.videocam : Icons.image,
                  color: Colors.white,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  reel.type == ReelType.video ? 'VIDEO' : 'IMAGE',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Bottom info with playing indicator
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (reel.title != null)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          reel.title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (reel.type == ReelType.video && isVideoPlaying)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'PLAYING',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                if (reel.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    reel.description!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Custom background with animated gradient
  Widget _buildCustomBackground(BuildContext context, AxisReelModel reel) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.transparent,
            reel.type == ReelType.video
                ? Colors.purple.withValues(alpha: 0.3)
                : Colors.blue.withValues(alpha: 0.3),
          ],
        ),
      ),
    );
  }
}
