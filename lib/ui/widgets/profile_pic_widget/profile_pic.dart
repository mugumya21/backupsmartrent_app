import 'package:smart_rent/ui/widgets/profile_pic_widget/profile_pic_layout.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    this.width = 100,
    this.height = 100,
    this.radius = 50,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ProfilePicLayout(
      width: width,
      height: height,
      radius: radius,
    );
  }
}
