import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/axis_reel_model.dart';
import '../state/axis_reels_state.dart';

/// Parameters for AxisReelsProvider
class AxisReelsProviderParams {
  final List<AxisReelModel>? reels;
  final int? maxConcurrentVideos;
  final int? crossAxisCount;

  const AxisReelsProviderParams({this.reels, this.maxConcurrentVideos, this.crossAxisCount});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AxisReelsProviderParams &&
          runtimeType == other.runtimeType &&
          reels == other.reels &&
          maxConcurrentVideos == other.maxConcurrentVideos &&
          crossAxisCount == other.crossAxisCount;

  @override
  int get hashCode => reels.hashCode ^ maxConcurrentVideos.hashCode ^ crossAxisCount.hashCode;
}

/// Provider for Axis Reels state with optional custom data
///
/// Usage:
/// ```dart
/// // With default data
/// ref.watch(axisReelsProvider(AxisReelsProviderParams()))
///
/// // With custom data
/// ref.watch(axisReelsProvider(AxisReelsProviderParams(reels: customReels)))
///
/// // With max concurrent videos
/// ref.watch(axisReelsProvider(AxisReelsProviderParams(maxConcurrentVideos: 3)))
/// ```
final axisReelsProvider = ChangeNotifierProvider.autoDispose.family<AxisReelsState, AxisReelsProviderParams>((
  ref,
  params,
) {
  final state = AxisReelsState(
    customReels: params.reels,
    maxConcurrentVideos: params.maxConcurrentVideos,
    crossAxisCount: params.crossAxisCount,
  );
  state.initialize();
  return state;
});
