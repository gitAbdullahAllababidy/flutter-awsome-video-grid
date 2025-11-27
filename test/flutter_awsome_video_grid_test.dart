import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_awsome_video_grid/flutter_awsome_video_grid.dart';

void main() {
  group('AxisReelModel', () {
    test('creates image reel correctly', () {
      const reel = AxisReelModel(
        id: 'test_1',
        url: 'https://example.com/image.jpg',
        type: ReelType.image,
        title: 'Test Image',
      );

      expect(reel.id, 'test_1');
      expect(reel.type, ReelType.image);
      expect(reel.title, 'Test Image');
      expect(reel.loopCount, 3); // Default value
    });

    test('creates video reel with custom loop count', () {
      const reel = AxisReelModel(
        id: 'test_2',
        url: 'https://example.com/video.mp4',
        type: ReelType.video,
        thumbnailUrl: 'https://example.com/thumb.jpg',
        title: 'Test Video',
        loopCount: 10,
      );

      expect(reel.id, 'test_2');
      expect(reel.type, ReelType.video);
      expect(reel.thumbnailUrl, 'https://example.com/thumb.jpg');
      expect(reel.loopCount, 10);
    });
  });

  group('DefaultReelsData', () {
    test('provides default reel flat list', () {
      final flatList = DefaultReelsData.flatList;

      expect(flatList.length, 30); // 30 items total
      expect(flatList[0].type, ReelType.image); // First item is image
      expect(flatList[1].type, ReelType.video); // Second item is video
    });

    test('creates custom grid from flat list', () {
      final flatItems = [
        const AxisReelModel(id: '1', url: 'url1', type: ReelType.image),
        const AxisReelModel(id: '2', url: 'url2', type: ReelType.video),
        const AxisReelModel(id: '3', url: 'url3', type: ReelType.image),
        const AxisReelModel(id: '4', url: 'url4', type: ReelType.video),
      ];

      final grid = DefaultReelsData.createCustomGrid(items: flatItems);

      expect(grid.length, 2); // 2 rows
      expect(grid[0].length, 2); // Each row has 2 items
      expect(grid[1].length, 2);
      expect(grid[0][0].id, '1');
      expect(grid[1][1].id, '4');
    });
  });
}
