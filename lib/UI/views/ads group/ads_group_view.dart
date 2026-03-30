// lib/ui/views/ad_groups/ad_groups_view.dart

import 'package:flutter/material.dart';
import 'package:google_adds/UI/Theme/apptheme.dart';
import 'package:google_adds/UI/views/ads%20group/ads_group_view_model.dart';
import 'package:google_adds/UI/widgets/loading_overlay.dart';
import 'package:google_adds/services/ad_models.dart';
import 'package:stacked/stacked.dart';


class AdGroupsView extends StackedView<AdGroupsViewModel> {
  const AdGroupsView({super.key});

  @override
  Widget builder(
      BuildContext context, AdGroupsViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ad Groups'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: viewModel.isBusy
          ? const LoadingOverlay()
          : RefreshIndicator(
              onRefresh: viewModel.refresh,
              color: AppColors.primary,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: viewModel.adGroups.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) =>
                    _buildCard(viewModel.adGroups[i]),
              ),
            ),
    );
  }

  Widget _buildCard(AdGroupModel ag) {
    final isActive = ag.status == AdGroupStatus.active;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.secondaryLight
                        : AppColors.warningLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Paused',
                    style: TextStyle(
                        fontSize: 11,
                        color: isActive
                            ? AppColors.secondary
                            : AppColors.warning,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Spacer(),
                Text('Bid: \$${ag.cpcBid.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Text(ag.name,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            Row(
              children: [
                _stat('Impressions', _fmt(ag.impressions)),
                _stat('Clicks', _fmt(ag.clicks)),
                _stat('CTR', '${ag.ctr.toStringAsFixed(2)}%'),
                _stat('Conv.', '${ag.conversions}'),
                _stat('Spend', '\$${ag.spend.toStringAsFixed(0)}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          Text(label,
              style: const TextStyle(
                  fontSize: 10, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  String _fmt(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }

  @override
  AdGroupsViewModel viewModelBuilder(BuildContext context) =>
      AdGroupsViewModel();

  @override
  void onViewModelReady(AdGroupsViewModel viewModel) =>
      viewModel.initialise();
}