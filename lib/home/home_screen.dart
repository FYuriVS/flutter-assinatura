import 'dart:typed_data';

import 'package:assinatura/home/my_painter.dart';
import 'package:assinatura/home/touch_points.dart';
import 'package:assinatura/home/visualizar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey globalKey = GlobalKey();

  final List<TouchPoints> points = [];

  StrokeCap strokeCap = StrokeCap.round;

  final strokeWidth = 3.0;

  TouchPoints _criaTouchPoints(renderBox, details) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appBarHeight = AppBar().preferredSize.height;
    final double totalHeight = statusBarHeight + appBarHeight;
    final offset = Offset(
      renderBox.globalToLocal(details.globalPosition).dx,
      renderBox.globalToLocal(details.globalPosition).dy - totalHeight,
    );
    return TouchPoints(
      offset: offset,
      paint: Paint()
        ..color = Colors.black
        ..strokeCap = strokeCap
        ..strokeWidth = strokeWidth
        ..isAntiAlias = true,
    );
  }

  void _visualizar(context) async {
    RenderRepaintBoundary boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Visualizar(
          pngBytes: pngBytes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assinatura'),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              points.add(_criaTouchPoints(renderBox, details));
            },
            onPanUpdate: (details) {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              setState(() {
                points.add(_criaTouchPoints(renderBox, details));
              });
            },
            onPanEnd: (details) {
              setState(() {
                points.add(
                  TouchPoints(
                    offset: Offset.infinite,
                    paint: Paint(),
                  ),
                );
              });
            },
            child: RepaintBoundary(
              key: globalKey,
              child: CustomPaint(
                painter: MyPainter(pointsList: points),
                size: Size.infinite,
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 1.0, // Defina a espessura da linha
              color: Colors.grey, // Defina a cor da linha
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              heroTag: 'fab2',
              onPressed: () {
                _visualizar(context);
              },
              child: const Icon(Icons.save),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 64,
            child: FloatingActionButton.extended(
              heroTag: 'fab1',
              onPressed: () {
                setState(() {
                  points.clear();
                });
              },
              icon: const Icon(Icons.edit),
              label: const Text('Corrigir'),
            ),
          ),
        ],
      ),
    );
  }
}
