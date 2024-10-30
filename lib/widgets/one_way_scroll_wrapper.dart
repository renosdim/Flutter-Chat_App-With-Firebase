import 'package:flutter/material.dart';

class OneWayScrollWrapper extends StatefulWidget {
  final List<Widget> screens;

  const OneWayScrollWrapper({Key? key, required this.screens}) : super(key: key);

  @override
  _OneWayScrollWrapperState createState() => _OneWayScrollWrapperState();
}

class _OneWayScrollWrapperState extends State<OneWayScrollWrapper> {
  final PageController _pageController = PageController(initialPage: 1);
  double _initialPositionX = 0.0;
  bool _isScrollingLeft = false;

  void _onHorizontalDragStart(DragStartDetails details) {
    _initialPositionX = details.globalPosition.dx;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    double deltaX = details.globalPosition.dx - _initialPositionX;

    // Only allow leftward scrolling from page 1 to page 0
    if (deltaX < 0 && _pageController.page == 1) {
      setState(() => _isScrollingLeft = true);
      _pageController.position.jumpTo(
        _pageController.position.pixels - deltaX.abs() * 0.1,
      );
    } else {
      setState(() => _isScrollingLeft = false);
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    // Snap to current page if scrolling is disabled
    if (_isScrollingLeft == false) {
      _pageController.animateToPage(
        _pageController.page!.round(),
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // Disable regular page scrolling
        children: widget.screens,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
