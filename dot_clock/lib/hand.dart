import 'package:flutter/material.dart';

import 'drawn_hand.dart';
import 'hand_data.dart';

class AnimatedHand extends StatefulWidget {
  AnimatedHand(
      {Key key,
      this.startRadians,
      this.endRadians,
      this.duration,
      this.handData})
      : super(key: key);

  final double startRadians;
  final double endRadians;
  final Duration duration;
  final HandData handData;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AnimatedHandState();
  }
}

class _AnimatedHandState extends State<AnimatedHand>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  double _interValRadians;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _interValRadians = widget.endRadians - widget.startRadians;

    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DrawnHand(
      handData: widget.handData,
      angleRadians: _animation.value * _interValRadians + widget.startRadians,
    );
  }
}
