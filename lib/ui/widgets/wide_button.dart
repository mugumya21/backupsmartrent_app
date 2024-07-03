import 'package:smart_rent/ui/themes/app_theme.dart';
import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  const WideButton({
    super.key,
    this.onPressed,
    required this.name,
    this.bgColor = AppTheme.primary,
    this.textStyle = const TextStyle(color: Colors.white),
  });

  final Function()? onPressed;
  final String name;
  final Color bgColor;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: FilledButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => bgColor),
          ),
          onPressed: onPressed,
          child: Text(
            name,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
