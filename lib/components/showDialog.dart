import 'package:flutter/material.dart';

ShowDialog(BuildContext context, String connect) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        connect,
        style: const TextStyle(color: Colors.black),
      ),
    ),
  );
}
