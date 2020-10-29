abstract class StringValidator {
  bool isValid(String value);
}

class NonEmptyStringValidator implements StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class EmailAndPasswordValidators {
  final StringValidator emailValidator = NonEmptyStringValidator();
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final String invalidEmailErrorText = "Email can't be empty";
  final String invalidPasswordErrorText = "Password can't be empty";
}

class ShopFieldsValidators {
  final StringValidator nameValidator = NonEmptyStringValidator();
  final StringValidator campusValidator = NonEmptyStringValidator();
  final StringValidator blockValidator = NonEmptyStringValidator();
  final String invalidNameErrorText = "Name can't be empty";
  final String invalidCampusErrorText = "Campus can't be empty";
  final String invalidBlockErrorText = "Block can't be empty";
}


class ItemFieldsValidators {
  final StringValidator nameValidator = NonEmptyStringValidator();
  final StringValidator priceValidator = NonEmptyStringValidator();
  final String invalidNameErrorText = "Name can't be empty";
  final String invalidPriceErrorText = "Price can't be empty";
}
