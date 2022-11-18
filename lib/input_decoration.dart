import 'package:flutter/material.dart';

InputDecoration inputDecoration(String hintText, IconData icon, {Widget? suffix}) => InputDecoration(
  prefixIcon: Icon(icon),
  hintText: hintText,
  filled: true,
  suffix: suffix,
  fillColor: const Color(0xffffffff),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
  ),
);