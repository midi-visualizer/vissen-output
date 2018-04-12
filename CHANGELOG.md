# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- A Circle context.

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
