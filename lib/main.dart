import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey controller = GlobalKey();
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('KTM Badge'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                RepaintBoundary(
                  key: controller,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/badge.jpeg',
                        height: MediaQuery.sizeOf(context).height / 1.2,
                      ),
                      Center(
                        child: Text(
                          nameController.text,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.sizeOf(context).width >= 1024
                                ? 40
                                : 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width >= 1024
                      ? MediaQuery.sizeOf(context).width / 2
                      : MediaQuery.sizeOf(context).width - 20,
                  child: TextField(
                    controller: nameController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.amber.shade50,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final RenderRepaintBoundary? boundary =
                        controller.currentContext!.findRenderObject()
                            as RenderRepaintBoundary?;

                    final ui.Image image = await boundary!.toImage(
                      pixelRatio: 3.0,
                    );

                    final ByteData? byteData =
                        await image.toByteData(format: ui.ImageByteFormat.png);

                    final Uint8List pngBytes = byteData!.buffer.asUint8List();

                    final base64 = base64Encode(pngBytes);

                    AnchorElement(
                      href: 'data:application/octet-stream;base64,$base64',
                    )
                      ..setAttribute('download',
                          '${nameController.text.trim().replaceAll(' ', '_').toLowerCase()}.png')
                      ..click();
                  },
                  child: const Text(
                    'Download',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
