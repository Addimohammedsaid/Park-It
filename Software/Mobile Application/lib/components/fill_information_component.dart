import 'dart:async';
import 'package:parkIt/components/base_component.dart';
import 'package:parkIt/locator.dart';
import 'package:parkIt/services/reservation_service.dart';
import 'package:parkIt/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

class FillInformationComponent extends BaseComponent {
  //========================== Services =========================//
  ReservationService reservationService = locator.get<ReservationService>();

  //========================= Controllers ======================//
  final _nameController = BehaviorSubject<String>();
  final _numberController = BehaviorSubject<String>();

  //======================== Streams ==========================//
  Stream get name$ => _nameController.stream;
  Stream get number$ => _numberController.stream;

  //======================== Sinks  ==========================//

  StreamSink<String> get name => _nameController.sink;
  StreamSink<String> get number => _numberController.sink;

  //======================= Getters & Setters  ================//

  // payment Method
  PaymentMethod _paymentMethod = PaymentMethod.AtDelivery;

  PaymentMethod get paymentMethod => _paymentMethod;

  void setPaymentMethod(PaymentMethod paymentMethod) {
    _paymentMethod = paymentMethod;
    notifyListeners();
  }

  //======================= Component onInit =====================//

  FillInformationComponent() {}

  //======================= Methods =======================//

  validate() {
    if (_nameController.hasValue && _numberController.hasValue) {
      return true;
    }
    _nameController.addError("error");
    _numberController.addError("error");
    return false;
  }

  //save to reservation service
  save() {
    this.reservationService.reservation.name = _nameController.value;
    this.reservationService.reservation.key = _numberController.value;
  }

  //======================= dispose =======================//
  @override
  void dispose() {
    _nameController?.close();
    _numberController?.close();
  }
}
