# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
## [0.6.1] - 2018-04-20
### Changed
- Improved, more descriptive comments.

## [0.6.0] - 2018-04-14
### Added
- Output filter support in PixelBuffer.
- More descriptive ContextErrors that are raised when contexts do not match.

### Changed
- Grid context now accepts a with and height instead of an aspect ratio.

## [0.5.1] - 2018-04-14
### Added
- PixelBuffer#finalize!.
- The convenience method Context::Cloud.scatter that randomly places n points.

### Fixed
- A bug in the Circle context caused the circle to be centered in (0,0), rather than in the center of the context.

## [0.5.0] - 2018-04-13
### Changed
- Changed the name of the Cloud module to Buffer to distance it from the cloud context.
- Moved all context to their own submodule.
- Changed the name of the PixelCloud to PixelBuffer to better indicate what it should be used for.
- Changed the name of the VixelCloud to VixelBuffer to better indicate what it should be used for.

### Removed
- The Grid class.

## [0.4.1] - 2018-04-13
### Added
- A Circle context.

### Changed
- Improved the documentation.

## [0.4.0] - 2018-04-10
### Added
- Output filters.
- Gamma filter.
- Quantizer filter.
- Introduced the more general concept of point clouds.
- Created the Context as a more general form of the GridContext.
- Create a new CloudContext that handles arbitrarily positioned Point objects.

### Changed
- Made the Grid into a special kind of Cloud.
- Made the VixelGrid into a VixelCloud.
- Made the PixelGrid into a PixelCloud.
- The GridContext is now a class instead of a module.
- The Stack is now longer a GridContext but instead accepts one as its first argument.
- The argument order of Vixel.new is now reversed, so that is is alphabetical.
- Renamed Stack -> VixelStack.
