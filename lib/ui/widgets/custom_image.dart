import 'package:cached_network_image/cached_network_image.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage(
    this.file, {
    super.key,
    this.width = 100,
    this.height = 100,
    this.bgColor = Colors.transparent,
    this.borderWidth = 0,
    this.borderColor,
    this.trBackground = false,
    this.isNetwork = true,
    this.radius = 50,
    this.imageFit = BoxFit.cover,
    this.canClose = false,
    this.isElevated = true,
    this.onClose,
    this.onTap,
  });

  final file;
  final double width;
  final double height;
  final double borderWidth;
  final Color? borderColor;
  final Color? bgColor;
  final bool trBackground;
  final bool isNetwork;
  final bool canClose;
  final bool isElevated;
  final double radius;
  final BoxFit imageFit;
  final Function()? onClose;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return _buildImage();
  }

  _buildImage() {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: (isElevated) ? [
                BoxShadow(
                  color: AppTheme.shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: .1,
                  offset: const Offset(0, 1), // changes position of shadow
                ),
              ] : null,
              image: (isNetwork)
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(file),
                      fit: imageFit,
                    )
                  : DecorationImage(
                      image: /*FileImage*/ AssetImage(file),
                      fit: imageFit,
                    ),
            ),
          ),
        ),
        if (canClose)
          Positioned(
            top: -13,
            right: -13,
            child: IconButton(
                onPressed: onClose,
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppTheme.red,
                  size: 24,
                )),
          ),
      ],
    );
  }
}
