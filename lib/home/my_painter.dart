import 'dart:ui' as ui;
import 'package:assinatura/home/touch_points.dart';
import 'package:flutter/material.dart';

class MyPainter extends CustomPainter {
  List<TouchPoints> pointsList;
  List<Offset> offsetPoints = [];

  MyPainter({required this.pointsList});

  @override
  void paint(Canvas canvas, Size size) {
    // // Linha do meio que serve de guia...
    // final centerPaint = Paint()
    //   ..color = Colors.grey
    //   ..strokeWidth = 2.0
    //   ..style = PaintingStyle.stroke;

    // final centerY = size.height / 2;
    // final startX = size.width * 0.025;
    // final endX = size.width * 0.9725;

    // canvas.drawLine(
    //   Offset(startX, centerY),
    //   Offset(endX, centerY),
    //   centerPaint,
    // );

    // Escrita do usuário
    for (var i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(
          pointsList[i].offset,
          pointsList[i + 1].offset,
          pointsList[i].paint,
        );
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].offset);
        offsetPoints.add(
          Offset(
            pointsList[i].offset.dx + 0.1,
            pointsList[i].offset.dy + 0.1,
          ),
        );
        canvas.drawPoints(
            ui.PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant MyPainter oldDelegate) {
    return true;
  }
}
