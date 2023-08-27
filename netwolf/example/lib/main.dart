import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:netwolf/netwolf.dart';
import 'package:netwolf_dio/netwolf_dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NetwolfController.instance.init();
  final navigatorKey = GlobalKey<NavigatorState>();

  runApp(
    MaterialApp(
      builder: (context, child) => NetwolfWidget(
        navigatorKey: navigatorKey,
        child: child ?? Container(),
      ),
      navigatorKey: navigatorKey,
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Netwolf Demo')),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  ElevatedButton(
                    onPressed: NetwolfController.instance.show,
                    child: const Text('Show'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Dio()
                        ..interceptors.add(NetwolfDioInterceptor())
                        ..get('https://pokeapi.co/api/v2/pokemon-form/132/');
                    },
                    child: const Text('Test API #1'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Dio()
                        ..interceptors.add(NetwolfDioInterceptor())
                        ..get('https://api.ipify.org?format=json');
                    },
                    child: const Text('Test API #2'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Dio()
                        ..interceptors.add(NetwolfDioInterceptor())
                        ..put('https://pokeapi.co/api/v2/pokemon-form/132/');
                    },
                    child: const Text('Test failed API #1'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Dio()
                        ..interceptors.add(NetwolfDioInterceptor())
                        ..post('https://api.ipify.org?format=json');
                    },
                    child: const Text('Test failed API #2'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
