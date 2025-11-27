import 'package:flutter/material.dart';
import 'package:flutter_awsome_video_grid/flutter_awsome_video_grid.dart';

/// Example demonstrating control over concurrent video playback
class ConcurrentVideosExample extends StatefulWidget {
  const ConcurrentVideosExample({super.key});

  @override
  State<ConcurrentVideosExample> createState() => _ConcurrentVideosExampleState();
}

class _ConcurrentVideosExampleState extends State<ConcurrentVideosExample> {
  int _maxConcurrentVideos = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Concurrent Videos Control',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Control panel
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black87,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Max Concurrent Videos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Currently: $_maxConcurrentVideos video${_maxConcurrentVideos > 1 ? 's' : ''} at once',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _maxConcurrentVideos.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: _maxConcurrentVideos.toString(),
                        activeColor: Colors.deepPurple,
                        onChanged: (value) {
                          setState(() {
                            _maxConcurrentVideos = value.toInt();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _maxConcurrentVideos.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getDescription(_maxConcurrentVideos),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          // Video grid
          Expanded(
            child: AxisReelsExploreScreen(
              key: ValueKey(_maxConcurrentVideos), // Rebuild when changed
              showAppBar: false,
              backgroundColor: Colors.grey[900],
              maxConcurrentVideos: _maxConcurrentVideos,
              showVideoIndicator: true, // Show indicator to see which are videos
            ),
          ),
        ],
      ),
    );
  }

  String _getDescription(int count) {
    switch (count) {
      case 1:
        return '⚡ Best for low-end devices - only 1 video plays at a time';
      case 2:
        return '✅ Recommended - good balance between UX and performance';
      case 3:
        return '🎬 Smooth experience - 3 videos can play simultaneously';
      case 4:
        return '🚀 Premium experience - requires good device';
      case 5:
        return '💪 Maximum videos - requires high-end device';
      default:
        return '';
    }
  }
}
