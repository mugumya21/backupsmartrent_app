import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:smart_rent/ui/widgets/profile_pic_widget/bloc/profile_pic_bloc.dart';
import 'package:smart_rent/ui/widgets/profile_pic_widget/widgets/no_pic.dart';
import 'package:smart_rent/ui/widgets/profile_pic_widget/widgets/pic_error.dart';
import 'package:smart_rent/ui/widgets/profile_pic_widget/widgets/pic_loading.dart';
import 'package:smart_rent/ui/widgets/profile_pic_widget/widgets/pic_success.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ProfilePicLayout extends StatefulWidget {
  const ProfilePicLayout({
    super.key,
    this.width = 100,
    this.height = 100,
    this.radius = 50,
  });

  final double width;
  final double height;
  final double radius;

  @override
  State<ProfilePicLayout> createState() => _ProfilePicLayoutState();
}

class _ProfilePicLayoutState extends State<ProfilePicLayout> {
  final _profilePicBloc = ProfilePicBloc();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilePicBloc, ProfilePicState>(
      bloc: _profilePicBloc,
      builder: (BuildContext context, ProfilePicState state) {
        if (state.status == ProfilePicStatus.initial) {
          _profilePicBloc.add(GetProfilePic());
        }
        if (state.status == ProfilePicStatus.success) {
          if (state.imageUrl != null) {
            return PicSuccess(
              state.imageUrl!,
              width: widget.width,
              height: widget.height,
              radius: widget.radius,
            );
          } else {
            return NoPic(
              width: widget.width,
              height: widget.height,
              radius: widget.radius,
              bgColor: AppTheme.whiteColor,
            );
          }
        }
        if (state.status == ProfilePicStatus.loading) {
          return PicLoading(
            width: widget.width,
            height: widget.height,
            radius: widget.radius,
            bgColor: AppTheme.whiteColor,
          );
        }
        if (state.status == ProfilePicStatus.error) {
          return PicError(
            width: widget.width,
            height: widget.height,
            radius: widget.radius,
            bgColor: AppTheme.whiteColor,
          );
        } else {
          return NoPic(
            width: widget.width,
            height: widget.height,
            radius: widget.radius,
            bgColor: AppTheme.whiteColor,
          );
        }
      },
    );
  }
}
