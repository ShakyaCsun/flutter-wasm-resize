import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

const isRunningWithWasm = bool.fromEnvironment('dart.tool.dart2wasm');

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hello ${isRunningWithWasm ? 'WASM' : 'JavaScript'}'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              color: Color(0xFF333333),
              child: Text('Lorem Ipsum'),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 5,
                children: List.generate(100, (index) {
                  if (index % 5 == 0) {
                    return Center(child: Chip(label: Text('$index')));
                  }
                  return Center(child: FlutterLogo());
                }),
              ),
            ),
          ],
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
    );
  }
}
