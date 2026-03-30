

import 'package:flutter/material.dart';
import 'package:google_adds/UI/Campaigns/Campaign_model%20.dart';
import 'package:google_adds/UI/Theme/apptheme.dart';


class CampaignStatusBadge extends StatelessWidget {
  final CampaignStatus status;

  const CampaignStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    switch (status) {
      case CampaignStatus.active:
        color = AppColors.secondary;
        label = 'Active';
        break;
      case CampaignStatus.paused:
        color = AppColors.warning;
        label = 'Paused';
        break;
      case CampaignStatus.removed:
        color = AppColors.error;
        label = 'Removed';
        break;
      case CampaignStatus.ended:
        color = AppColors.textSecondary;
        label = 'Ended';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}