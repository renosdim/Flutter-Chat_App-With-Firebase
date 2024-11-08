
import 'package:flutter/material.dart';

class MultiInheritedWrapper extends StatelessWidget {
  final List<InheritedWidget Function(Widget)> inheritedWidgets;
  final Widget child;

  const MultiInheritedWrapper({
    super.key,
    required this.inheritedWidgets,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Wrap the child with each inherited widget in the list
    Widget wrappedChild = child;
    for (final inheritedWidget in inheritedWidgets.reversed) {
      wrappedChild = inheritedWidget(wrappedChild);
    }
    return wrappedChild;
  }
}