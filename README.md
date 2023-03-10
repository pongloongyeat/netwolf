[![Build status](https://github.com/pongloongyeat/netwolf/actions/workflows/flutter.yaml/badge.svg)](https://github.com/pongloongyeat/netwolf/actions/workflows/flutter.yaml)
[![Pub package](https://img.shields.io/pub/v/netwolf.svg)](https://pub.dev/packages/netwolf)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Inspired by [Netfox](https://github.com/kasketis/netfox) on iOS. Netwolf allows for easy debugging of network requests made in your app via the use of interceptors (see [Supported clients](#supported-clients)).

## Overview

https://user-images.githubusercontent.com/31680656/215766013-24dbfd34-292f-4448-bd4d-76858ce97933.mp4

## Installation

Add the following line to your `pubspec.yaml` file.

```yaml
netwolf: ^0.3.0
```

## Usage

To use Netwolf, wrap `NetwolfWidget` with your home widget.

```dart
void main() {
  runApp(
    const MaterialApp(
      home: NetwolfWidget(
        child: HomePage(),
      ),
    ),
  );
}
```

To display Netwolf, tap anywhere (that is not a `GestureDetector`) 5 times or call `NetwolfController.instance.show()`.

By default, Netwolf is only enabled for debug mode. Taping it 5 times or calling `NetwolfController.instance.show()` does nothing if `NetwolfWidget.enabled` is `false`. To change this behaviour, set the behaviour in `NetwolfWidget`'s constructor.

```dart
void main() {
  runApp(
    const MaterialApp(
      home: NetwolfWidget(
        enabled: true,
        child: HomePage(),
      ),
    ),
  );
}
```

## Supported clients

- [Dio](https://pub.dev/packages/dio) via `NetwolfDioInterceptor`.
- [http](https://pub.dev/packages/http) with [http_interceptor](https://pub.dev/packages/http_interceptor) via `NetwolfHttpInterceptor` (planned).

## Adding responses manually

For unsupported clients, you can manually log the response using `NetwolfController.instance.addResponse`. For example,

```dart
try {
  NetwolfController.instance.addRequest(
    someWayOfIdentifyingThisRequest,
    method: HttpRequestMethod.get,
    url:'path/to/api',
    requestHeaders: null,
    requestBody: null,
  );

  final response = await client.get('path/to/api');
  
  NetwolfController.instance.addResponse(
    someWayOfIdentifyingThisRequest,
    responseCode: response.statusCode,
    responseHeaders: response.headers,
    responseBody: response.data,
    method: null,
    url: null,
    requestHeaders: null,
    requestBody: null,
  );

  return response.data;
} on NetworkException catch (e) {
  NetwolfController.instance.addResponse(
    someWayOfIdentifyingThisRequest,
    responseCode: e.statusCode,
    responseHeaders: e.headers,
    responseBody: e.data,
    method: null,
    url: null,
    requestHeaders: null,
    requestBody: null,
  );

  return null;
}
```

## Usage with `MaterialApp.router`

To use `Netwolf` with `MaterialApp.router`, you will need to create an empty page/shell route that contains the `NetwolfWidget` wrapped around the main widget. For [AutoRoute](https://pub.dev/packages/auto_route), it would look something like this

```dart
class NetwolfAutoRouteEmptyPage extends EmptyRouterPage with AutoRouteWrapper {
  const NetwolfAutoRouteEmptyPage({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return NetwolfWidget(child: this);
  }
}

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute<void>(
      page: NetwolfAutoRouteEmptyPage,
      initial: true,
      children: [
        AutoRoute<void>(page: HomePage, initial: true),
        // Other pages...
      ],
    ),
  ],
)
class AppRouter extends _$AppRouter {}
```

or, in [GoRouter](https://pub.dev/packages/go_router)

```dart
final router = GoRouter(
  routes: [
    ShellRoute(
      builder: (_, __, child) => NetwolfWidget(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomePage()),
        // Other pages...
      ],
    ),
  ],
);
```