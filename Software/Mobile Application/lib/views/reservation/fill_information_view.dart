import 'package:flutter/material.dart';
import 'package:parkIt/components/fill_information_component.dart';
import 'package:parkIt/utils/enum.dart';
import 'package:parkIt/utils/size_config.dart';
import '../base_view.dart';

class FillInformationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<FillInformationComponent>(
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
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Text("Fill Your informations"),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Form(
                          child: Column(
                            children: [
                              StreamBuilder<String>(
                                  stream: component.name$,
                                  builder: (context, snapshot) {
                                    return TextField(
                                      onChanged: (e) => component.name.add(e),
                                      decoration: InputDecoration(
                                          errorText: snapshot.error,
                                          labelText: "Full name"),
                                    );
                                  }),
                              SizedBox(
                                height: 20.0,
                              ),
                              StreamBuilder<String>(
                                  stream: component.number$,
                                  builder: (context, snapshot) {
                                    return TextField(
                                      onChanged: (e) => component.number.add(e),
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          errorText: snapshot.error,
                                          labelText:
                                              "Plate number or RFID TAG"),
                                    );
                                  })
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Payment Method :"),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  color: component.paymentMethod ==
                                          PaymentMethod.CreditCard
                                      ? Theme.of(context).accentColor
                                      : Colors.grey,
                                  iconSize: SizeConfig.imageSizeMultiplier * 20,
                                  icon: Icon(Icons.payment),
                                  onPressed: () => component.setPaymentMethod(
                                      PaymentMethod.CreditCard),
                                ),
                                IconButton(
                                  color: component.paymentMethod ==
                                          PaymentMethod.AtDelivery
                                      ? Theme.of(context).accentColor
                                      : Colors.grey,
                                  iconSize: SizeConfig.imageSizeMultiplier * 20,
                                  icon: Icon(Icons.attach_money),
                                  onPressed: () => component.setPaymentMethod(
                                      PaymentMethod.AtDelivery),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              bottomNavigationBar: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: FlatButton(
                  onPressed: () {
                    if (component.validate()) {
                      Navigator.pushNamed(context, "/confirm");
                      component.save();
                    }
                  },
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Continue",
                    style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2.5,
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                  color: Theme.of(context).accentColor,
                ),
              ),
            ));
  }
}
