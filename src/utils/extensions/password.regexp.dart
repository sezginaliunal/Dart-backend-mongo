extension PasswordValidator on String {
  bool isValidPassword() {
    if (length < 8) {
      return false;
    }

    // Şifrenin en az bir büyük harf, bir küçük harf ve bir rakam içermesi gerektiğini kontrol edelim
    // if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$').hasMatch(this)) {
    //   return false;
    // }

    // if (!RegExp(r'^(?=.*[!@#$%^&*(),.?":{}|<>]).+$').hasMatch(this)) {
    //   return false;
    // }

    return true;
  }
}
