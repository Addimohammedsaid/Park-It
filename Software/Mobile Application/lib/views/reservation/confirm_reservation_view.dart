import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:parkIt/components/reservation_component.dart';
import 'package:parkIt/models/parking.model.dart';
import 'package:parkIt/utils/size_config.dart';
import 'package:parkIt/widgets/loading.dart';

import '../base_view.dart';

class ConfirmReservationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<ReservationComponent>(
        onComponentReady: (component) async {
          await component
              .loadParking(component.reservationService.reservation.parking);
        },
        builder: (context, component, child) => StreamBuilder<Parking>(
            stream: component.parking$,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Loading();
              else
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                    leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black87,
                        ),
                        onPressed: () => Navigator.pop(context)),
                    automaticallyImplyLeading: false,
                  ),
                  body: SafeArea(
                      minimum: EdgeInsets.symmetric(horizontal: 20.0),
                      child: ListView(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: Column(
                              children: [
                                Text("${snapshot.data.name}"),
                                Text("Oran, Algeria")
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text("Operated by"),
                                  trailing: Text("Park It"),
                                ),
                                ListTile(
                                    title: Text("Spot"),
                                    trailing: RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          style: TextStyle(color: Colors.grey),
                                          text:
                                              "${snapshot.data.spots.isNotEmpty ? snapshot.data.spots[0].key : "Close"}"),
                                    ]))),
                                ListTile(
                                    title: Text("End Time"),
                                    trailing: RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          style: TextStyle(color: Colors.grey),
                                          text:
                                              "${component.reservationService.reservation.endTime}"),
                                      TextSpan(
                                          style: TextStyle(color: Colors.green),
                                          text: " Edit",
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              print('pressed');
                                            })
                                    ]))),
                                ListTile(
                                    title: Text("Plate number"),
                                    trailing: RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          style: TextStyle(color: Colors.grey),
                                          text:
                                              "${component.reservationService.reservation.key}"),
                                      TextSpan(
                                          style: TextStyle(color: Colors.green),
                                          text: " Edit",
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              print('pressed');
                                            })
                                    ]))),
                                ListTile(
                                  title: Text("address"),
                                  trailing: Text("${snapshot.data.address}"),
                                ),
                                ListTile(
                                    title: Text("Price"),
                                    trailing: RichText(
                                        text: TextSpan(children: <TextSpan>[
                                      TextSpan(
                                          style: TextStyle(color: Colors.grey),
                                          text: "${component.price} DA "),
                                    ]))),
                              ],
                            ),
                          ),
                          Text("${component.errorMessage}",
                              style: TextStyle(color: Colors.red)),
                        ],
                      )),
                  bottomNavigationBar: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    child: FlatButton(
                      onPressed: () async {
                        bool result = await component.reserve();
                        // if (result)
                        //   Navigator.pushNamed(context, "/direction",
                        //       arguments: snapshot.data);
                      },
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Pay  (${component.price}) DA",
                        style: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 2.5,
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                );
            }));
  }
}
