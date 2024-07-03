import 'package:flutter/material.dart';
import 'package:smart_rent/ui/themes/app_theme.dart';

class NoDataWidget extends StatelessWidget {
  final String message;
  final VoidCallback onPressed;
  final String subText;

  const NoDataWidget(
      {super.key, required this.message, required this.onPressed, required this.subText});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.inActiveColor,
            ),
          ),
           Text(
            "Click the \"+\" button to add $subText",
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.inActiveColor,
            ),
          ),
          const Text(
            "Or click the refresh button to refresh",
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.inActiveColor,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: onPressed, child: Icon(Icons.refresh))
        ],
      ),
    );
  }
}
