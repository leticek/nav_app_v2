import 'package:email_validator/email_validator.dart';

class Validator {
  static String validateEmail(String val) =>
      EmailValidator.validate(val.trimRight().trimLeft())
          ? null
          : 'Email není validní.';

  static String validatePasswordComplexity(String val) {
    if (val.isEmpty) return 'Zadejte heslo';
    if (val.length < 6) return 'Heslo musí mít minimálně 6 znaků.';
    if (!val.contains(RegExp('[a-z]'))) {
      return 'Heslo musí obsahovat alespoň 1 malé písmeno.';
    }
    if (!val.contains(RegExp('[A-Z]'))) {
      return 'Heslo musí obsahovat alespoň 1 velké písmeno.';
    }
    if (!val.contains(RegExp('[0-9]'))) {
      return 'Heslo musí obsahovat alespoň 1 číslici.';
    }
    return null;
  }

  static String comparePasswords(String password, String confirmPassword) {
    if ((password.compareTo(confirmPassword) == 0) &&
        (password.isNotEmpty || password != null)) return null;
    if (confirmPassword.isEmpty) return 'Potvrďte heslo.';
    return 'Hesla se musí shodovat.';
  }

  static String checkError(String response) {
    switch (response) {
      case 'invalid-email':
        return 'Emailová adresa není validní.';
        break;
      case 'user-disabled':
        return 'Účet je zablokován.';
        break;
      case 'user-not-found':
        return 'Účet s touto adresou neexistuje.';
        break;
      case 'wrong-password':
        return 'Chybné heslo.';
        break;
      case 'email-already-in-use':
        return 'Účet s touto adresou již existuje';
        break;
      case 'weak-password':
        return 'Slabé heslo.';
        break;
      case 'account-exists-with-different-credential':
        return 'Přihlašte se pomocí emailu a hesla.';
        break;
      default:
        return 'Někde se stala chyba.';
        break;
    }
  }
}
