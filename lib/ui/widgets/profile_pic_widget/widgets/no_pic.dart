import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:flutter/material.dart';

class NoPic extends StatelessWidget {
  const NoPic({
    super.key,
    this.width = 100,
    this.height = 100,
    this.radius = 50,
    this.bgColor,
  });

  final double width;
  final double height;
  final double radius;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }

  _buildImage() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: Icon(
          Icons.person,
          color: AppTheme.darker,
          size: width,
        ),
      ),
    );
  }
}
