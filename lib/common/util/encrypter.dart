import 'dart:convert';

class Encrypter {
  static String encrypt(String plaintext, String key) {
    if (plaintext.isEmpty) {
      return "";
    }
    StringBuffer ciphertext = StringBuffer();
    for (int i = 0; i < plaintext.length; i++) {
      int charCode = plaintext.codeUnitAt(i) ^ key.codeUnitAt(i % key.length);
      ciphertext.write(String.fromCharCode(charCode));
    }
    return base64.encode(utf8.encode(ciphertext.toString())); // 使用 Base64 编码
  }

  static String decrypt(String ciphertext, String key) {
    if (ciphertext.isEmpty) {
      return "";
    }
    ciphertext =
        String.fromCharCodes(base64.decode(ciphertext)); // 使用 Base64 解码
    StringBuffer plaintext = StringBuffer();
    for (int i = 0; i < ciphertext.length; i++) {
      int charCode = ciphertext.codeUnitAt(i) ^ key.codeUnitAt(i % key.length);
      plaintext.write(String.fromCharCode(charCode));
    }
    return plaintext.toString();
  }
}
