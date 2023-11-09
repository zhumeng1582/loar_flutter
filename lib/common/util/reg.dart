class Reg {
  static bool isPhone(String input) {
    RegExp mobile = RegExp(r"1[0-9]\d{9}$");
    return mobile.hasMatch(input);
  }

  //6~16位数字和字符组合
  static bool isLoginPassword(String input) {
    RegExp mobile = RegExp(r"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$");
    return mobile.hasMatch(input);
  }
}
