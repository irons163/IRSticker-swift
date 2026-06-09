# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2026-06-09

### Added
- `IRStickerViewDelegate` now declares `stickerView(stickerView:imageForRightTopControl:)` as a protocol requirement, making the right-top control symmetric with the other three corners and matching the documented API. A default implementation is still provided, so existing conformers continue to compile without changes.
- Comprehensive unit-test suite covering initialization, scale clamping, bounded movement, hit testing, delegate synchronization, control toggling, simultaneous gesture recognition, and `IRStickerGestureRecognizer`.

### Changed
- Refactored `IRStickerView` to remove duplicated logic. Extracted scale clamping (`clampedScale`), boundary clamping (`boundedCenter`), tap-recognizer setup, control relocation, and delegate image application into focused helpers. Public API and runtime behavior are unchanged.

### Fixed
- Right-top control callbacks are now dispatched through the protocol witness table, so delegate overrides are reliably invoked.

## [2.0.0] - Previous release

- Baseline Swift implementation of IRSticker.

[2.1.0]: https://github.com/irons163/IRSticker-swift/compare/2.0.0...2.1.0
[2.0.0]: https://github.com/irons163/IRSticker-swift/releases/tag/2.0.0
