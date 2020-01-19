import 'package:flutter/material.dart';

enum HandType { second, minute, hour }

class HandData {
  HandData({this.handType, this.dotRadius, this.handSize, this.color})
      : assert(dotRadius != null),
        assert(handSize != null),
        assert(color != null),
        assert(handType != null);

  final HandType handType;
  final double dotRadius;
  final double handSize;
  final Color color;
}

final kSecondHand = HandData(
  handType: HandType.second,
  dotRadius: 9.2,
  handSize: 0.92,
  color: Color(0xFFEA4335),
);
final kMinuteHand = HandData(
  handType: HandType.minute,
  dotRadius: 11.4,
  handSize: 0.75,
  color: Color(0xFFFBBC04),
);
final kHourHand = HandData(
  handType: HandType.hour,
  dotRadius: 11.4,
  handSize: 0.44,
  color: Color(0xFF4285F4),
);
