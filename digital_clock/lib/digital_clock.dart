// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flare_flutter/flare_actor.dart';

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF3498db),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Color(0xFF3498db),
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

class Bubble extends StatelessWidget {
  Bubble({this.message, this.time, this.delivered, this.isMe});

  final String message, time;
  final delivered, isMe;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.white : Colors.greenAccent.shade100;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              // Padding(
              // padding: EdgeInsets.only(right: 48.0),
              // child:
              Text(message),
              // ),
              // Positioned(
              //   bottom: 0.0,
              //   right: 0.0,
              //   child: Row(
              //     children: <Widget>[
              //       Text(time,
              //           style: TextStyle(
              //             color: Colors.black38,
              //             fontSize: 10.0,
              //           )),
              //       SizedBox(width: 3.0),
              //       Icon(
              //         icon,
              //         size: 12.0,
              //         color: Colors.black38,
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        )
      ],
    );
  }
}

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
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
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 3.5;
    final offset = -fontSize / 7;
    bool hasexploded = false;
    // final defaultStyle = TextStyle(
    //   color: colors[_Element.text],
    //   fontFamily: 'PressStart2P',
    //   fontSize: fontSize,
    //   shadows: [
    //     Shadow(
    //       blurRadius: 0,
    //       color: colors[_Element.shadow],
    //       offset: Offset(10, 0),
    //     ),
    //   ],
    // );

    return Container(
      color: colors[_Element.background],
      child: Center(
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                // print("asdf");
                // if(hasexploded)
              },
              child: Container(
                child: Image.asset("assets/mee6.png", height: 250),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Bubble(
                  message: 'Look at me, I am Mr Meeseeks.',
                  time: '12:00',
                  delivered: true,
                  isMe: false,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      hour,
                      style: TextStyle(fontSize: 50, color: Colors.white),
                    ),
                    Text(
                      ":",
                      style: TextStyle(fontSize: 50, color: Colors.white),
                    ),
                    Text(
                      minute,
                      style: TextStyle(fontSize: 50, color: Colors.white),
                    ),
                    // Text(":"),
                    // Text(minute),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
