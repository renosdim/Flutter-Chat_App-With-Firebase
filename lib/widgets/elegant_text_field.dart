import 'package:flutter/material.dart';
Widget elegantTextField(String message, Function(String) onChanged, TextEditingController? controller) {
  return Container(
    height: 45,
    child: TextField(
      onChanged: (query) {
        onChanged(query);
      },
      controller: controller,
      decoration: InputDecoration(
        hintText: message,
        hintStyle: TextStyle(fontFamily: 'San Francisco', color: Colors.black,fontSize: 13),
        prefixIcon: Icon(Icons.search_rounded, color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.black, width: 2)
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.black, width: 2)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.deepPurple, width: 2)
        ),
      ),
    ),
  );
}