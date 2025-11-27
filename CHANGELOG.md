# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-11-27

### Added
- 🎬 **Concurrent Videos Control** - `maxConcurrentVideos` parameter to limit simultaneous playing videos (1-5)
- 🎨 **Custom Foreground Builder** - `foregroundBuilder` for custom item overlays with access to play state
- 🎨 **Custom Background Builder** - `backgroundBuilder` for custom backgrounds and gradients
- 📜 **Flexible Scroll Management** - `manageScroll` and `scrollController` parameters
- 📜 **Embeddable Widget** - Can now be embedded in `CustomScrollView`, `TabView`, etc.
- 🚀 **Auto Media Type Detection** - `AxisReelModel.fromUrl()` automatically detects image/video from URL
- 💾 **Smart Caching** - Enhanced caching with old cache fallback
- ⚙️ **Configurable UI** - `showAppBar`, `showVideoIndicator`, `showPlayButton` parameters
- 🎯 **Better Defaults** - Transparent background and no scaffold by default (better for embedding)
- 📦 **AxisReelsProviderParams** - New params class for provider configuration

### Changed
- **BREAKING**: `showAppBar` default changed from `true` to `false`
- **BREAKING**: `backgroundColor` default changed from `Colors.black` to `Colors.transparent`
- **BREAKING**: Provider now uses `AxisReelsProviderParams` instead of `List<AxisReelModel>?`
- `DefaultReelsData.rows` deprecated in favor of `DefaultReelsData.flatList`
- Row generation now handled internally by state
- Video indicator icon now hidden by default (`showVideoIndicator: false`)

### Enhanced
- Better performance with concurrent video management
- Improved caching strategy for images
- Optimized resource management
- Cleaner default UI (no unnecessary icons)

### Documentation
- Added `FEATURES.md` - Complete features guide
- Added `CONCURRENT_VIDEOS.md` - Concurrent videos performance guide
- Added `DEFAULT_CHANGES.md` - Default configuration changes
- Added `REFACTORING_SUMMARY.md` - Complete changelog
- Updated README.md with all new features
- Added example for concurrent videos control
- Added example for custom foreground builders
- Added example for nested scroll scenarios

## [1.0.0] - 2024-11-26

### Added
- Initial release of Flutter Awsome Video Grid package
- `AxisReelsExploreScreen` widget for displaying video grid layout
- Support for both default sample data and custom data
- `AxisReelModel` data model with support for images and videos
- `DefaultReelsData` utility class with 15 rows of sample data
- Automatic video playback management based on visibility
- Finite video looping with configurable loop count
- 800ms autoplay delay to prevent unnecessary loading
- 90% visibility threshold for better UX
- Cached image loading via `cached_network_image`
- Cached video playback via `cached_video_player_plus`
- Riverpod state management with family provider support
- Grid layout showing 2 items per row
- Muted videos by default
- Video play/pause toggle on tap
- Video reset/replay button
- Comprehensive documentation and examples

### Features
- ✨ Automatic video playback management
- 🎬 Finite video looping
- ⚡ Smart autoplay delay
- 💾 Cached loading for images and videos
- 👀 90% visibility threshold
- 🔇 Muted by default
- 📱 Grid layout (2 per row)
- 📐 Auto height calculation

## [Unreleased]

### Planned
- Volume control UI
- Full-screen video playback
- Share functionality
- Like/favorite functionality
- Video progress indicator
- Network error handling UI
- Offline mode support
- Performance optimizations for large datasets
- Customizable grid columns (beyond 2)
