import 'package:flutter/material.dart';
import 'package:notes/src/presentation/app_colors.dart';

void showSnackBar(BuildContext context, String message, IconData icon) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        showCloseIcon: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
        ),
        duration: const Duration(seconds: 1),
        content: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.milkWhite,
            ),
            const SizedBox(width: 10),
            Text(
              message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.milkWhite, fontSize: 16),
            ),
          ],
        ),
        backgroundColor: AppColors.darkBrown,
      ),
    );
