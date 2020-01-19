// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'hand_data.dart';

class DrawnHand extends StatelessWidget {
  const DrawnHand({
    @required this.handData,
    @required this.angleRadians,
  })  : assert(handData != null),
        assert(angleRadians != null);

  final HandData handData;
  final double angleRadians;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _HandPainter(
              angleRadians: angleRadians,
              color: handData.color,
              handSize: handData.handSize,
              dotRadius: handData.dotRadius,
              handType: handData.handType),
        ),
      ),
    );
  }
}

class _HandPainter extends CustomPainter {
  _HandPainter({
    @required this.angleRadians,
    @required this.color,
    @required this.handSize,
    @required this.dotRadius,
    @required this.handType,
  })  : assert(angleRadians != null),
        assert(color != null),
        assert(handSize != null),
        assert(dotRadius != null),
        assert(handType != null),
        assert(handSize >= 0.0),
        assert(handSize <= 1.0);

  double angleRadians;
  Color color;
  double handSize;
  double dotRadius;
  HandType handType;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    // We want to start at the top, not at the x-axis, so add pi/2.
    final angle = angleRadians - math.pi / 2.0;
    final length = size.shortestSide * 0.5 * handSize;
    final position = center + Offset(math.cos(angle), math.sin(angle)) * length;
    final dotPaint = Paint()..color = color;

    canvas.drawCircle(position, dotRadius * size.shortestSide / 300, dotPaint);

    if (handType == HandType.hour) {
      final circlePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = dotRadius * size.shortestSide / 300;
      canvas.drawCircle(center,
          length - 1.5 * dotRadius * size.shortestSide / 300, circlePaint);
    }
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
        oldDelegate.dotRadius != dotRadius ||
        oldDelegate.angleRadians != angleRadians ||
        oldDelegate.color != color;
  }
}
