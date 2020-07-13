import 'package:flutter/material.dart';
import 'package:parkIt/components/user_component.dart';
import 'package:parkIt/views/base_view.dart';

class UserDashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<UserComponent>(
      builder: (context, component, child) => Container(
        child: Text("UserDashboard works !"),
      ),
    );
  }
}
