<!-- 
### Features
### Fixes
### Changes
### Documentation
### Workflow
### Tests
### Others
 -->

## 0.3.0

### Features
- Added a `completed` property to `NetwolfResponse` to indicate whether or not a request has completed.
- Added a `responseTime` property to `NetwolfResponse`, indicating how long the request took to produce a response.

### Changes
- Remove usage of shake and switch to tap-based show/hide to work more easily around simulators.
- Removed `NetwolfResponseWithRelativeTimestamp` class.
- Removed `extended_text` package.
- Updated UI

### Workflow
- Fix failed build on Flutter 3.7 due to `extended_text` package.

## 0.2.0

### Fixes
 - Fixed an issue where Netwolf would show up on each phone shake/call to `NetwolfController.show`.

### Others
- Added a separator to the request ListView to make it less confusing when there are many requests.
- Set the request ListView's item's URL `maxLines` to 3.
- Use middle ellipses on overflow for URLs for the request ListView's item.
- Constrained the height of the request ListView's item's height.

## 0.1.0

### Documentation
- Added documentation for `NetwolfResponse`, `NetwolfResponseWithRelativeTimestamp`, `NetwolfController.addResponse` and `NetwolfController.clearResponses`.

### Workflow
- Added CI to run tests on commit.

### Tests
- Added simple tests.

### Others
- Updated request ListView styling.

## 0.0.3

- Updated license.

## 0.0.2

- Added license.

## 0.0.1

- Initial pre-release.
