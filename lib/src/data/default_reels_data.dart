import '../models/axis_reel_model.dart';

/// Default sample data for the Axis Reels grid
/// Provides a flat list of reels with automatic media type detection from URLs
class DefaultReelsData {
  DefaultReelsData._();

  /// Get the default reels as a flat list (30 items total)
  /// Media type (image/video) is automatically determined from URL extension
  static List<AxisReelModel> get flatList => [
        // Item 1: Landscape
        AxisReelModel.fromUrl(
          id: '1',
          url: 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=900&auto=format&fit=crop&q=20',
          title: 'Beautiful Landscape',
        ),
        // Item 2: Video 1
        AxisReelModel.fromUrl(
          id: '2',
          url: 'https://d2594vc0rpodpd.cloudfront.net/vids/packages/2025/04/10/af543177-374f-4947-bdbc-a3bacd65e42b_clip.mp4',
          thumbnailUrl: 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=900&auto=format&fit=crop&q=20',
          title: 'Amazing Video 1',
          loopCount: 25,
        ),
        // Item 3: Ocean
        AxisReelModel.fromUrl(
          id: '3',
          url: 'https://images.unsplash.com/photo-1518837695005-2083093ee35b?w=900&auto=format&fit=crop&q=20',
          title: 'Ocean Waves',
        ),
        // Item 4: Video 2
        AxisReelModel.fromUrl(
          id: '4',
          url: 'https://d2594vc0rpodpd.cloudfront.net/vids/post/2025/06/23/1bd946af-27cd-4ff7-85a3-733010f47cd2_clip.mp4',
          thumbnailUrl: 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=900&auto=format&fit=crop&q=20',
          title: 'Adventure Video',
          loopCount: 25,
        ),
        // Item 5: City
        AxisReelModel.fromUrl(
          id: '5',
          url: 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=900&auto=format&fit=crop&q=20',
          title: 'City Lights',
        ),
        // Item 6: Video 3
        AxisReelModel.fromUrl(
          id: '6',
          url: 'https://d2594vc0rpodpd.cloudfront.net/vids/post/2025/05/26/2a1735d7-10b4-46a3-b585-998c7f67b18f_clip.mp4',
          thumbnailUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=900&auto=format&fit=crop&q=20',
          title: 'Urban Life',
          loopCount: 25,
        ),
        // Item 7: Nature
        AxisReelModel.fromUrl(
          id: '7',
          url: 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=900&auto=format&fit=crop&q=20',
          title: 'Forest Trail',
        ),
        // Item 8: Video 4
        AxisReelModel.fromUrl(
          id: '8',
          url: 'https://d2594vc0rpodpd.cloudfront.net/vids/packages/2025/04/10/f965c476-298d-4c63-99b8-555bdc68b034_clip.mp4',
          thumbnailUrl: 'https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=900&auto=format&fit=crop&q=20',
          title: 'Nature Walk',
          loopCount: 25,
        ),
        // Item 9: Technology
        AxisReelModel.fromUrl(
          id: '9',
          url: 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=900&auto=format&fit=crop&q=20',
          title: 'Tech World',
        ),
        // Item 10: Video 5
        AxisReelModel.fromUrl(
          id: '10',
          url: 'https://d2594vc0rpodpd.cloudfront.net/vids/packages/2025/04/19/a03a15ed-e776-4858-9247-df622b3aa1c8_clip.mp4',
          thumbnailUrl: 'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=900&auto=format&fit=crop&q=20',
          title: 'Innovation',
          loopCount: 25,
        ),
        // Item 11: Space
        AxisReelModel.fromUrl(
          id: '11',
          url: 'https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?w=900&auto=format&fit=crop&q=20',
          title: 'Galaxy',
        ),
        // Item 12: Video 6
        AxisReelModel.fromUrl(
          id: '12',
          url: 'https://d2594vc0rpodpd.cloudfront.net/vids/packages/2025/04/10/cfd211b2-089e-44a3-885e-ad0cbbb30efb_clip.mp4',
          thumbnailUrl: 'https://images.unsplash.com/photo-1502134249126-9f3755a50d78?w=900&auto=format&fit=crop&q=20',
          title: 'Space Exploration',
          loopCount: 25,
        ),
        // Item 13: Food
        AxisReelModel.fromUrl(
          id: '13',
          url: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=900&auto=format&fit=crop&q=20',
          title: 'Delicious Food',
        ),
        // Item 14: Video 7
        AxisReelModel.fromUrl(
          id: '14',
          url: 'https://d2594vc0rpodpd.cloudfront.net/vids/packages/2025/04/10/a4d71594-60ad-4011-a12d-e78342a37e82_clip.mp4',
          thumbnailUrl: 'https://images.unsplash.com/photo-1493770348161-369560ae357d?w=900&auto=format&fit=crop&q=20',
          title: 'Cooking Show',
          loopCount: 25,
        ),
        // Item 15: Art
        AxisReelModel.fromUrl(
          id: '15',
          url: 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=900&auto=format&fit=crop&q=20',
          title: 'Modern Art',
        ),
        // Item 16: Video 8
        AxisReelModel.fromUrl(
          id: '16',
          url: 'https://d2594vc0rpodpd.cloudfront.net/vids/packages/2025/04/20/5ef3d25f-81e5-4b4a-9172-90ad4c279e05_clip.mp4',
          thumbnailUrl: 'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?w=900&auto=format&fit=crop&q=20',
          title: 'Creative Process',
          loopCount: 25,
        ),
        // Item 17: Sports
        AxisReelModel.fromUrl(
          id: '17',
          url: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=900&auto=format&fit=crop&q=20',
          title: 'Sports Action',
        ),
        // Item 18: Video 9
        AxisReelModel.fromUrl(
          id: '18',
          url: 'https://d2594vc0rpodpd.cloudfront.net/vids/packages/2025/04/20/d27090f4-6e09-4bb4-917c-eb988e674a17_clip.mp4',
          thumbnailUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=900&auto=format&fit=crop&q=20',
          title: 'Athletic Performance',
          loopCount: 25,
        ),
        // Item 19: Travel
        AxisReelModel.fromUrl(
          id: '19',
          url: 'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=900&auto=format&fit=crop&q=20',
          title: 'Travel Destination',
        ),
        // Item 20: Video 10
        AxisReelModel.fromUrl(
          id: '20',
          url: 'https://d2594vc0rpodpd.cloudfront.net/vids/packages/2025/04/10/9bf8cb2d-0a69-47a4-8bc6-c932b9876b68_clip.mp4',
          thumbnailUrl: 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=900&auto=format&fit=crop&q=20',
          title: 'Travel Journey',
          loopCount: 25,
        ),
        // Item 21: Architecture
        AxisReelModel.fromUrl(
          id: '21',
          url: 'https://images.unsplash.com/photo-1487958449943-2429e8be8625?w=900&auto=format&fit=crop&q=20',
          title: 'Modern Architecture',
        ),
        // Item 22: Video 11
        AxisReelModel.fromUrl(
          id: '22',
          url: 'https://d2594vc0rpodpd.cloudfront.net/vids/post/2025/06/10/87ed3cd9-6c45-45c2-b8d0-d16fa4c78c72_clip.mp4',
          thumbnailUrl: 'https://images.unsplash.com/photo-1448630360428-65456885c650?w=900&auto=format&fit=crop&q=20',
          title: 'Architectural Wonder',
          loopCount: 25,
        ),
        // Item 23: Animals
        AxisReelModel.fromUrl(
          id: '23',
          url: 'https://images.unsplash.com/photo-1546026423-cc4642628d2b?w=900&auto=format&fit=crop&q=20',
          title: 'Wildlife',
        ),
        // Item 24: Video 12
        AxisReelModel.fromUrl(
          id: '24',
          url: 'https://d2594vc0rpodpd.cloudfront.net/vids/packages/2025/04/10/aec5fc11-84bf-4faa-a166-f3a5ce96819d_clip.mp4',
          thumbnailUrl: 'https://images.unsplash.com/photo-1564349683136-77e08dba1ef7?w=900&auto=format&fit=crop&q=20',
          title: 'Animal Kingdom',
          loopCount: 25,
        ),
        // Item 25: Music
        AxisReelModel.fromUrl(
          id: '25',
          url: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=900&auto=format&fit=crop&q=20',
          title: 'Music Vibes',
        ),
        // Item 26: Video 13
        AxisReelModel.fromUrl(
          id: '26',
          url: 'https://d2594vc0rpodpd.cloudfront.net/vids/post/2025/05/20/852d06a6-3fd6-4f1a-8a78-931a1d3fb8cc_clip.mp4',
          thumbnailUrl: 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=900&auto=format&fit=crop&q=20',
          title: 'Musical Performance',
          loopCount: 25,
        ),
        // Item 27: Fashion
        AxisReelModel.fromUrl(
          id: '27',
          url: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=900&auto=format&fit=crop&q=20',
          title: 'Fashion Style',
        ),
        // Item 28: Video 14
        AxisReelModel.fromUrl(
          id: '28',
          url: 'https://d2594vc0rpodpd.cloudfront.net/vids/packages/2025/05/25/6c6d90c7-2197-499c-88fe-7c97333fb7ab_clip.mp4',
          thumbnailUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b?w=900&auto=format&fit=crop&q=20',
          title: 'Style Showcase',
          loopCount: 25,
        ),
        // Item 29: Fitness
        AxisReelModel.fromUrl(
          id: '29',
          url: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=900&auto=format&fit=crop&q=20',
          title: 'Fitness Goals',
        ),
        // Item 30: Video 15
        AxisReelModel.fromUrl(
          id: '30',
          url: 'https://d2594vc0rpodpd.cloudfront.net/vids/packages/2025/04/10/fd0004ef-a14b-464b-a24b-1b9e430ca3b5_clip.mp4',
          thumbnailUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=900&auto=format&fit=crop&q=20',
          title: 'Workout Routine',
          loopCount: 25,
        ),
      ];

  /// Legacy method for backward compatibility
  /// Returns the flat list organized into rows of 2 items each
  @Deprecated('Use flatList instead and handle row generation in AxisReelsState')
  static List<List<AxisReelModel>> get rows => _createRows(flatList);

  /// Create rows from a flat list (2 items per row)
  /// Useful for creating test or example data
  static List<List<AxisReelModel>> createCustomGrid({
    required List<AxisReelModel> items,
  }) {
    return _createRows(items);
  }

  /// Internal helper to generate rows
  static List<List<AxisReelModel>> _createRows(List<AxisReelModel> items) {
    final rows = <List<AxisReelModel>>[];
    for (var i = 0; i < items.length; i += 2) {
      if (i + 1 < items.length) {
        rows.add([items[i], items[i + 1]]);
      } else {
        rows.add([items[i]]);
      }
    }
    return rows;
  }
}
