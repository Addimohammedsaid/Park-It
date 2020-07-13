import 'package:flutter/material.dart';
import 'package:parkIt/components/reservation_component.dart';
import 'package:parkIt/models/parking.model.dart';
import 'package:parkIt/utils/size_config.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:parkIt/utils/validator.dart';
import '../base_view.dart';

class ReservationView extends StatelessWidget {
  Parking parking;
  ReservationView({this.parking});
  @override
  Widget build(BuildContext context) {
    return BaseView<ReservationComponent>(
        onComponentReady: (component) async {
          component.loadParking(parking.key);
        },
        builder: (context, component, child) => Scaffold(
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
                  child: StreamBuilder<Parking>(
                      stream: component.parking$,
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return ListView(
                            children: [
                              StreamBuilder<DateTime>(
                                  stream: component.endTime$,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasError)
                                      return Text("");
                                    else
                                      return Container(
                                        decoration:
                                            BoxDecoration(color: Colors.red),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20.0),
                                        child: Text(
                                          "${snapshot.error}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0),
                                        ),
                                      );
                                  }),
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
                                      title: Text("Duration"),
                                      trailing: GestureDetector(
                                        child: StreamBuilder<DateTime>(
                                            stream: component.endTime$,
                                            builder: (context, snapshot) {
                                              return Text(
                                                "${snapshot.data ?? "Add Time"}",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .accentColor),
                                              );
                                            }),
                                        onTap: () =>
                                            DatePicker.showDateTimePicker(
                                                context,
                                                showTitleActions: true,
                                                minTime: DateTime.now(),
                                                onConfirm: (date) {
                                          print('confirm $date');
                                          component.endTime.add(date);
                                        }, locale: LocaleType.en),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text("address"),
                                      trailing:
                                          Text("${snapshot.data.address}"),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        else
                          return Center(child: CircularProgressIndicator());
                      })),
              bottomNavigationBar: StreamBuilder<DateTime>(
                  stream: component.endTime$,
                  builder: (context, snapshot) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                      child: FlatButton(
                        onPressed: () {
                          if (snapshot.hasError) return null;
                          if (snapshot.data == null) {
                            component.endTime
                                .addError("Define reservation time");
                            return null;
                          }
                          component.save();
                          Navigator.pushNamed(context, "/fill");
                        },
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Reserve  (${component.getPrice()}) DA",
                          style: TextStyle(
                              fontSize: SizeConfig.textMultiplier * 2.5,
                              color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                        color: Theme.of(context).accentColor,
                      ),
                    );
                  }),
            ));
  }
}
