import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:parkIt/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

class BaseComponent extends ChangeNotifier {
  //
  final _stateController = BehaviorSubject<ViewState>();

  //======================== Streams ==========================//
  Stream get state$ => _stateController.stream;

  //======================== Sinks  ==========================//

  StreamSink<ViewState> get state => _stateController.sink;

  void dispose() {
    _stateController?.close();
  }
}
