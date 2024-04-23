import 'dart:convert';
import 'package:crypto/crypto.dart';

extension StringHashExtension on String {
  String hashString({Hash hashAlgorithm = sha256}) {
    var bytes = utf8.encode(this);
    var hash = hashAlgorithm.convert(bytes);
    return hash.toString();
  }

  bool verifyHash(String hashedString, {Hash hashAlgorithm = sha256}) {
    // Verilen stringin hash değerini al
    var thisHash = hashString(hashAlgorithm: hashAlgorithm);

    // Verilen hash ile bu stringin hash'i eşleşiyorsa true döndür, aksi halde false döndür
    return thisHash == hashedString;
  }
}
