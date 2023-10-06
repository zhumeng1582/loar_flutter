

import 'dart:convert';
import 'package:crypto/crypto.dart';

String macToHex(String mac) {
  // Remove colons and convert to bytes
  List<int> bytes = utf8.encode(mac.replaceAll(':', ''));

  // Compute SHA256 hash
  Digest hash = sha256.convert(bytes);

  // Convert first 4 bytes of hash to hex
  String hexCode = hash.bytes.sublist(0, 2).map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  return hexCode;
}