import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';
import 'package:pointycastle/asymmetric/api.dart';

class EncryptUtil {
  /// 异或对称 Base64 加密
  static String xorBase64Encode(String res, String key) {
    String encode = xorCode(res, key);
    encode = encodeBase64(encode);
    return encode;
  }

  /// 异或对称 Base64 解密
  static String xorBase64Decode(String res, String key) {
    String encode = decodeBase64(res);
    encode = xorCode(encode, key);
    return encode;
  }

  /// Base64加密字符串
  static String encodeBase64(String data) {
    var content = utf8.encode(data);
    var digest = base64Encode(content);
    return digest;
  }

  /// Base64解密字符串
  static String decodeBase64(String data) {
    List<int> bytes = base64Decode(data);
    String result = utf8.decode(bytes);
    return result;
  }

  /// 异或对称加密
  static String xorCode(String res, String key) {
    List<String> keyList = key.split(',');
    List<int> codeUnits = res.codeUnits;
    List<int> codes = [];
    for (int i = 0, length = codeUnits.length; i < length; i++) {
      int code = codeUnits[i] ^ int.parse(keyList[i % keyList.length]);
      codes.add(code);
    }
    return String.fromCharCodes(codes);
  }

  /// 根据公钥进行加密
  /// [file] 'assets/data/rsa_public_key.pem'
  /// [msg] 待加密明文
  static Future<String> encryptByFile(String file, String msg) async {
    var publicKeyStr = await rootBundle.loadString(file);
    RSAPublicKey publicKey = RSAKeyParser().parse(publicKeyStr) as RSAPublicKey;
    final encrypter = Encrypter(RSA(publicKey: publicKey));

    List<int> sourceBytes = utf8.encode(msg);
    int inputLen = sourceBytes.length;
    int maxLen = 117;
    List<int> totalBytes = [];
    for (var i = 0; i < inputLen; i += maxLen) {
      int endLen = inputLen - i;
      List<int> item;
      if (endLen > maxLen) {
        item = sourceBytes.sublist(i, i + maxLen);
      } else {
        item = sourceBytes.sublist(i, i + endLen);
      }
      totalBytes.addAll(encrypter.encryptBytes(item).bytes);
    }
    return base64.encode(totalBytes);
  }

  /// 根据公钥内容进行加密
  /// [publicKeyText] 公钥内容，支持没有header的方式
  /// [msg] 待加密明文
  static Future<String> encryptByPublicKeyText(String publicKeyText, String msg) async {
    if (!publicKeyText.contains('BEGIN PUBLIC KEY')) {
      publicKeyText = '-----BEGIN PUBLIC KEY-----\n' + publicKeyText + '\n-----END PUBLIC KEY-----';
    }
    RSAPublicKey publicKey = RSAKeyParser().parse(publicKeyText) as RSAPublicKey;
    final encrypter = Encrypter(RSA(publicKey: publicKey));

    List<int> sourceBytes = utf8.encode(msg);
    int inputLen = sourceBytes.length;
    int maxLen = 117;
    List<int> totalBytes = [];
    for (var i = 0; i < inputLen; i += maxLen) {
      int endLen = inputLen - i;
      List<int> item;
      if (endLen > maxLen) {
        item = sourceBytes.sublist(i, i + maxLen);
      } else {
        item = sourceBytes.sublist(i, i + endLen);
      }
      totalBytes.addAll(encrypter.encryptBytes(item).bytes);
    }
    return base64.encode(totalBytes);
  }

  /// 根据私钥解密
  /// [file] 私钥文件 'assets/data/rsa_private_key.pem'
  /// [msg] 待解密内容
  static Future<String> decodeByFile(String file, String msg) async {
    var publicKeyStr = await rootBundle.loadString(file);
    RSAPublicKey publicKey = RSAKeyParser().parse(publicKeyStr) as RSAPublicKey;
    final encrypter = Encrypter(RSA(publicKey: publicKey));

    Uint8List sourceBytes = base64.decode(msg);
    int inputLen = sourceBytes.length;
    int maxLen = 128;
    List<int> totalBytes = [];
    for (var i = 0; i < inputLen; i += maxLen) {
      int endLen = inputLen - i;
      Uint8List item;
      if (endLen > maxLen) {
        item = sourceBytes.sublist(i, i + maxLen);
      } else {
        item = sourceBytes.sublist(i, i + endLen);
      }
      totalBytes.addAll(encrypter.decryptBytes(Encrypted(item)));
    }
    return utf8.decode(totalBytes);
  }

  /// 根据私钥解密
  /// [file] 私钥文件 'assets/data/rsa_private_key.pem'
  /// [msg] 待解密内容
  static Future<String> decodeByPrivateKeyText(String privateKeyText, String msg) async {
    RSAPublicKey publicKey = RSAKeyParser().parse(privateKeyText) as RSAPublicKey;
    final encrypter = Encrypter(RSA(publicKey: publicKey));

    Uint8List sourceBytes = base64.decode(msg);
    int inputLen = sourceBytes.length;
    int maxLen = 128;
    List<int> totalBytes = [];
    for (var i = 0; i < inputLen; i += maxLen) {
      int endLen = inputLen - i;
      Uint8List item;
      if (endLen > maxLen) {
        item = sourceBytes.sublist(i, i + maxLen);
      } else {
        item = sourceBytes.sublist(i, i + endLen);
      }
      totalBytes.addAll(encrypter.decryptBytes(Encrypted(item)));
    }
    return utf8.decode(totalBytes);
  }
}
