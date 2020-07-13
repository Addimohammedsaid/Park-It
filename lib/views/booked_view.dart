import 'package:flutter/material.dart';
import 'package:parkIt/components/booked_component.dart';
import 'package:parkIt/models/reservation.model.dart';

import 'base_view.dart';

class BookedView extends StatelessWidget {
  const BookedView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<BookedComponent>(
        builder: (context, component, child) => Scaffold(
              body: SafeArea(
                  child: ListView(
                children: [
                  Container(
                    child: TextField(
                      onSubmitted: (e) => component.getReservation(e),
                    ),
                  ),
                  Container(
                    child: StreamBuilder<Reservation>(
                        stream: component.reservation$,
                        builder: (context, snapshot) {
                          if (snapshot.hasData)
                            return Column(
                              children: [
                                ListTile(
                                  leading: Text("${snapshot.data.name}"),
                                ),
                                ListTile(
                                  leading: Text("${snapshot.data.endTime}"),
                                )
                              ],
                            );
                          else
                            return Text("No Reservation Found");
                        }),
                  ),
                ],
              )),
            ));
  }
}
