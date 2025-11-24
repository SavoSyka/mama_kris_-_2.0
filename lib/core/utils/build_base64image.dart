import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

Widget buildBase64Image(String base64String) {
  try {
    Uint8List bytes = base64Decode(base64String);

    return Image.memory(
      bytes,
      fit: BoxFit.contain,
    );
  } catch (e) {
    return const Icon(Icons.broken_image, size: 40, color: Colors.grey);
  }
}
