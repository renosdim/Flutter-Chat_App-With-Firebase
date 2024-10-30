import 'package:flutter/material.dart';

abstract class PicWidgetFormat extends StatelessWidget{
  final List<String>? profilePics;
  const PicWidgetFormat({this.profilePics,super.key});
  @override
  Widget build(BuildContext context);

  PicWidgetFormat copyWith(List<String>? profilePics);
}