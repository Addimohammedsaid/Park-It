import 'dart:async';

mixin Validator {
  static final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  //Email validator

  var emailValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains(emailRegex)) {
      sink.add(email);
    } else {
      sink.addError("Email invalide");
    }
  });

  //passwordValidator

  var passwordValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 5)
      sink.add(password);
    else {
      sink.addError("le mot de passe doit comporter 6 caractères ou plus");
    }
  });

  //title,address ,city ,salary validator

  var emptyValuesValidator =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length > 0)
      sink.add(value);
    else
      sink.addError('Veuillez Remplir le champ addresse');
  });

  var userNameValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (username, sink) {
    if (username.length > 1)
      sink.add(username);
    else {
      sink.addError(
          "le nom d'utilisateur doit comporter au moins 1 caractères   ");
    }
  });

  var phoneNumberValidator = StreamTransformer<String, String>.fromHandlers(
      handleData: (phoneNumber, sink) {
    if (phoneNumber.length > 9)
      sink.add(phoneNumber);
    else {
      sink.addError("ce numéro de téléphone n'est pas valide");
    }
  });
}
