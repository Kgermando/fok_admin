class RegExpIsValide {
  final isValidPhone = RegExp(r"^\+?0[0-9]{10}$");
  final isValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final isValidPassword =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  final isValidName =
      RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");

  final isValideVente = RegExp(r"^\d{10}$");

  static List<String> passwordValidator(String text) {
    var test = text;
    List<String> errors = [];
    if (test.contains(RegExp(r'[0-9]'))) {
      errors.add("Text should have at least one number");
    }
    if (test.length < 7 || test.length > 20) {
      errors.add("Password should be between 7 and 20 caracters long");
    }
    return errors;
  }

  String? validateEmail(String? value) {
    RegExp regex = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$');
    if (value != null && value.isEmpty) {
      return 'Ce champs est obligatoire';
    } else if (!regex.hasMatch(value!)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }
}
