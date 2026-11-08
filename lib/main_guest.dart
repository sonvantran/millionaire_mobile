import 'package:flutter/material.dart';
import 'guest_picker/guest_picker_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const GuestPickerPage(),
  ));
}