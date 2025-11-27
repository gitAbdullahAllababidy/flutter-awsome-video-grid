enum ReelType { image, video }

class AxisReelModel {
  final String id;
  final String url;
  final ReelType type;
  final String? thumbnailUrl;
  final String? title;
  final String? description;
  final int loopCount; // For video finite looping

  const AxisReelModel({
    required this.id,
    required this.url,
    required this.type,
    this.thumbnailUrl,
    this.title,
    this.description,
    this.loopCount = 3, // Default to 3 loops for videos
  });

  /// Factory constructor to automatically determine type from URL
  factory AxisReelModel.fromUrl({
    required String id,
    required String url,
    String? thumbnailUrl,
    String? title,
    String? description,
    int loopCount = 3,
  }) {
    return AxisReelModel(
      id: id,
      url: url,
      type: _getTypeFromUrl(url),
      thumbnailUrl: thumbnailUrl,
      title: title,
      description: description,
      loopCount: loopCount,
    );
  }

  static ReelType _getTypeFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path.toLowerCase();
      // Common video extensions
      if (path.endsWith('.mp4') || 
          path.endsWith('.mov') || 
          path.endsWith('.avi') || 
          path.endsWith('.mkv') ||
          path.endsWith('.webm')) {
        return ReelType.video;
      }
    } catch (e) {
      // If URL parsing fails, default to image
    }
    return ReelType.image;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AxisReelModel &&
        other.id == id &&
        other.url == url &&
        other.type == type &&
        other.thumbnailUrl == thumbnailUrl &&
        other.title == title &&
        other.description == description &&
        other.loopCount == loopCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        url.hashCode ^
        type.hashCode ^
        thumbnailUrl.hashCode ^
        title.hashCode ^
        description.hashCode ^
        loopCount.hashCode;
  }
}
