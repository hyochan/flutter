// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';

/// This sample application creates a hard to render frame, causing the
/// driver script to race the GPU thread. If the driver script wins the
/// race, it will screenshot the previous frame. If the GPU thread wins
/// it, it will screenshot the latest frame.
void main() {
  enableFlutterDriverExtension();

  runApp(new Toggler());
}

class Toggler extends StatefulWidget {
  @override
  State<Toggler> createState() => new TogglerState();
}

class TogglerState extends State<Toggler> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('FlutterDriver test'),
        ),
        body: new Material(
          child: new Column(
            children: <Widget>[
              new FlatButton(
                key: const ValueKey<String>('toggle'),
                child: const Text('Toggle visibility'),
                onPressed: () {
                  setState(() {
                    _visible = !_visible;
                  });
                },
              ),
              new Expanded(
                child: new ListView(
                  children: _buildRows(_visible ? 10 : 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> _buildRows(int count) {
  return new List<Widget>.generate(count, (int i) {
    return new Row(
      children: _buildCells(i / count),
    );
  });
}

/// Builds cells that are known to take time to render causing a delay on the
/// GPU thread.
List<Widget> _buildCells(double epsilon) {
  return new List<Widget>.generate(15, (int i) {
    return new Expanded(
      child: new Material(
        // A magic color that the test will be looking for on the screenshot.
        color: const Color(0xffff0102),
        borderRadius: new BorderRadius.all(new Radius.circular(i.toDouble() + epsilon)),
        elevation: 5.0,
        child: const SizedBox(height: 10.0, width: 10.0),
      ),
    );
  });
}