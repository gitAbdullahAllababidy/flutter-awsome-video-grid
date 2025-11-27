import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_awsome_video_grid/flutter_awsome_video_grid.dart';

/// Example showing how to use AxisReelsExploreScreen with DraggableScrollableSheet
/// This prevents dual scroll behavior by coordinating scroll physics
class DraggableSheetExample extends StatelessWidget {
  const DraggableSheetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background content (fixed)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepPurple.shade900,
                  Colors.black,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.video_library,
                    size: 100,
                    color: Colors.white24,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Pull up to see videos',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // DraggableScrollableSheet with video grid
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.2,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // Title
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.video_collection, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Video Gallery',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(color: Colors.white12, height: 1),

                    // Video grid with coordinated scrolling
                    Expanded(
                      child: ProviderScope(
                        child: AxisReelsExploreScreen(
                          showAppBar: false,
                          manageScroll: true,
                          scrollController: scrollController,
                          // Use ClampingScrollPhysics for smooth coordination
                          physics: const ClampingScrollPhysics(),
                          backgroundColor: Colors.transparent,
                          showMediaTypeIcon: true,
                          maxConcurrentVideos: 2,
                          padding: const EdgeInsets.all(16),
                          itemSpacing: 12,
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
