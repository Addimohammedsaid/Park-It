import 'package:flutter/material.dart';
import 'package:parkIt/components/base_component.dart';
import 'package:provider/provider.dart';

import '../locator.dart';

class BaseView<T extends BaseComponent> extends StatefulWidget {
  final Widget Function(BuildContext context, T value, Widget child) builder;
  final Function(T) onComponentReady;

  BaseView({@required this.builder, this.onComponentReady});

  @override
  _BaseViewState<T> createState() => _BaseViewState();
}

class _BaseViewState<T extends BaseComponent> extends State<BaseView<T>> {
  T component = locator<T>();

  @override
  void initState() {
    if (widget.onComponentReady != null) {
      widget.onComponentReady(component);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        create: (context) => component,
        child: Consumer<T>(builder: widget.builder));
  }
}
