import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SideBarLeft extends StatefulWidget {
  SideBarLeft({super.key});

  @override
  State<SideBarLeft> createState() => _SideBarLeftState();
}

class _SideBarLeftState extends State<SideBarLeft>
    with SingleTickerProviderStateMixin<SideBarLeft> {
  final bool isSideBaropened = false;
  AnimationController? _animationController;
  StreamController<bool>? isSideBaropenedStreamController;
  Stream<bool>? isSideBaropenedStream;
  StreamSink<bool>? isSideBaropenedSink;
  final _animationDuration = const Duration(milliseconds: 800);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSideBaropenedStreamController = PublishSubject<bool>();
    isSideBaropenedStream = isSideBaropenedStreamController?.stream;
    isSideBaropenedSink = isSideBaropenedStreamController?.sink;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController?.dispose();
    isSideBaropenedStreamController?.close();
    isSideBaropenedSink?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
        initialData: false,
        stream: isSideBaropenedStream,
        builder: (context, snapshot) {
          return AnimatedPositioned(
            duration: _animationDuration,
            top: 0,
            bottom: 0,
            left: isSideBaropened ? 0 : 0,
            right: isSideBaropened ? 0 : screenwidth - 30,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  color: Colors.amberAccent,
                )),
                Align(
                  alignment: Alignment(0, 0.25),
                  child: Container(
                    height: 100,
                    width: 30,
                    color: Colors.blue,
                    child: Center(
                      child: AnimatedIcon(
                          icon: AnimatedIcons.arrow_menu,
                          progress: _animationController!.view),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
