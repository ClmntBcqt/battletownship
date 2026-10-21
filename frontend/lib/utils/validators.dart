class Validators {
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Veuillez saisir un mot de passe';
    }

    const passwordFormatMessage =
        "Le mot de passe doit contenir au moins 8 caractères, 1 majuscule et 1 minuscule et 1 chiffre";

    if (password.length < 8) return passwordFormatMessage;

    const upper = r"[A-Z]";
    const lower = r"[a-z]";
    final upperRegex = RegExp(upper);
    final lowerRegex = RegExp(lower);
    if (!upperRegex.hasMatch(password) || !lowerRegex.hasMatch(password)) {
      return passwordFormatMessage;
    }

    const digit = r"[0-9]";
    final digitRegx = RegExp(digit);
    if (!digitRegx.hasMatch(password)) return passwordFormatMessage;

    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Veuillez saisir votre adresse e-mail';
    }

    const pattern =
        r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';

    final regex = RegExp(pattern);

    if (!regex.hasMatch(email.trim())) {
      return 'Veuillez saisir une adresse e-mail valide';
    }

    return null;
  }

  static String? validateUsername(String? username) {
    if (username == null || username.trim().isEmpty) {
      return "Veuillez saisir un nom d'utilisateur";
    }

    return null;
  }
}
