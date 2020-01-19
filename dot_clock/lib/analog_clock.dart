// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import 'hand.dart';
import 'hand_data.dart';

final radiansPerTick = radians(360 / 60);
final radiansPerHour = radians(360 / 12);

class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();

  var _minute = 60;
  var _hour = 24;
  var _weekday = '';

  Widget _animatedSecondHand;
  Widget _animatedMinuteHand;
  Widget _animatedHourHand;

  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);

    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();

      if (_minute != _now.minute) {
        _animatedSecondHand = AnimatedHand(
          key: UniqueKey(),
          startRadians: _now.second * radiansPerTick,
          endRadians: radians(360),
          duration: Duration(seconds: 60 - _now.second),
          handData: kSecondHand,
        );

        if (_minute == 60) {
          _minute = 0;
        }
        double minuteEndRadians = _now.minute * radiansPerTick;
        if (_now.minute == 0) {
          minuteEndRadians = radians(360);
        }
        _animatedMinuteHand = AnimatedHand(
          key: UniqueKey(),
          startRadians: _minute * radiansPerTick,
          endRadians: minuteEndRadians,
          duration: Duration(seconds: 2),
          handData: kMinuteHand,
        );
        _minute = _now.minute;
      }

      if (_hour != _now.hour) {
        if (_hour == 24) {
          _hour = 0;
        }
        double hourEndRadians = _now.hour * radiansPerHour;
        if (_now.hour == 0) {
          hourEndRadians = radians(720);
        }
        _animatedHourHand = AnimatedHand(
          key: UniqueKey(),
          startRadians: _hour * radiansPerHour,
          endRadians: hourEndRadians,
          duration: Duration(seconds: 2),
          handData: kHourHand,
        );
        _hour = _now.hour;
      }

      _weekday = DateFormat('E').format(_now);

      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // There are many ways to apply themes to your clock. Some are:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter_clock_helper package).
    //  - Override the Theme.of(context).colorScheme.
    //  - Create your own [ThemeData], demonstrated in [AnalogClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            backgroundColor: Color(0xFFFFFFFF),
          )
        : Theme.of(context).copyWith(
            backgroundColor: Color(0xFF3C4043),
          );

    final time = DateFormat.Hms().format(DateTime.now());

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        color: customTheme.backgroundColor,
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: _animatedSecondHand,
            ),
            AnimatedSwitcher(
              duration: Duration(seconds: 2),
              child: _animatedMinuteHand,
            ),
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: _animatedHourHand,
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    _weekday,
                    style: TextStyle(
                        color: Color(0xFFFC7762),
                        fontSize: 24.0,
                        fontFamily: 'Raleway'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
