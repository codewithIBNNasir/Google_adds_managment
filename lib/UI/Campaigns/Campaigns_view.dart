// lib/ui/views/campaigns/campaigns_view.dart

import 'package:flutter/material.dart';
import 'package:google_adds/UI/Campaigns/Campaign_model%20.dart';
import 'package:google_adds/UI/Campaigns/Campaigns_view_model.dart';
import 'package:google_adds/UI/Theme/apptheme.dart';
import 'package:google_adds/UI/widgets/Campaign_status_badge.dart';
import 'package:google_adds/UI/widgets/loading_overlay.dart';
import 'package:stacked/stacked.dart';

class CampaignsView extends StackedView<CampaignsViewModel> {
  const CampaignsView({super.key});

  @override
  Widget builder(
      BuildContext context, CampaignsViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Campaigns'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
            tooltip: 'New Campaign',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort by',
            onSelected: viewModel.setSortBy,
            itemBuilder: (_) => viewModel.sortOptions
                .map((s) => PopupMenuItem(
                      value: s,
                      child: Row(
                        children: [
                          if (viewModel.sortBy == s)
                            const Icon(Icons.check,
                                size: 16, color: AppColors.primary),
                          if (viewModel.sortBy != s)
                            const SizedBox(width: 16),
                          const SizedBox(width: 8),
                          Text(
                            s[0].toUpperCase() + s.substring(1),
                            style: TextStyle(
                                color: viewModel.sortBy == s
                                    ? AppColors.primary
                                    : AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
      body: viewModel.isBusy
          ? const LoadingOverlay()
          : Column(
              children: [
                _buildSearchAndFilter(viewModel),
                _buildSummaryBar(viewModel),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: viewModel.refresh,
                    color: AppColors.primary,
                    child: viewModel.campaigns.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: viewModel.campaigns.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) =>
                                _buildCampaignCard(
                                    context,
                                    viewModel.campaigns[index],
                                    viewModel),
                          ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchAndFilter(CampaignsViewModel vm) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          TextField(
            onChanged: vm.setSearch,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search campaigns...',
              hintStyle:
                  const TextStyle(fontSize: 14, color: AppColors.textHint),
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.textHint, size: 20),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip(
                    'All', vm.statusFilter == null, () => vm.setStatusFilter(null)),
                const SizedBox(width: 6),
                _filterChip('Active', vm.statusFilter == CampaignStatus.active,
                    () => vm.setStatusFilter(CampaignStatus.active)),
                const SizedBox(width: 6),
                _filterChip('Paused', vm.statusFilter == CampaignStatus.paused,
                    () => vm.setStatusFilter(CampaignStatus.paused)),
                const SizedBox(width: 6),
                const VerticalDivider(width: 16),
                const SizedBox(width: 6),
                _filterChip('Search', vm.typeFilter == CampaignType.search,
                    () => vm.setTypeFilter(vm.typeFilter == CampaignType.search ? null : CampaignType.search)),
                const SizedBox(width: 6),
                _filterChip('Display', vm.typeFilter == CampaignType.display,
                    () => vm.setTypeFilter(vm.typeFilter == CampaignType.display ? null : CampaignType.display)),
                const SizedBox(width: 6),
                _filterChip('Video', vm.typeFilter == CampaignType.video,
                    () => vm.setTypeFilter(vm.typeFilter == CampaignType.video ? null : CampaignType.video)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.divider),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildSummaryBar(CampaignsViewModel vm) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Row(
        children: [
          Text(
            '${vm.campaigns.length} campaigns',
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          Text(
            'Total Spend: \$${vm.totalSpend.toStringAsFixed(0)}',
            style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignCard(BuildContext context, CampaignModel campaign,
      CampaignsViewModel vm) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/campaigns/detail',
          arguments: campaign),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _typeIcon(campaign.type),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(campaign.name,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 2),
                        Text(campaign.typeLabel,
                            style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  CampaignStatusBadge(status: campaign.status),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => vm.toggleCampaignStatus(campaign),
                    child: Container(
                      width: 36,
                      height: 20,
                      decoration: BoxDecoration(
                        color: campaign.status == CampaignStatus.active
                            ? AppColors.secondary
                            : AppColors.divider,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 200),
                        alignment:
                            campaign.status == CampaignStatus.active
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildBudgetBar(campaign),
              const SizedBox(height: 12),
              Row(
                children: [
                  _metricChip(
                      'Impressions',
                      _formatNum(campaign.impressions)),
                  _metricChip('Clicks', _formatNum(campaign.clicks)),
                  _metricChip(
                      'CTR', '${campaign.ctr.toStringAsFixed(2)}%'),
                  _metricChip('Conv.', '${campaign.conversions}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetBar(CampaignModel campaign) {
    final pct = (campaign.budgetUtilization / 100).clamp(0.0, 1.0);
    Color barColor = AppColors.primary;
    if (pct > 0.9) barColor = AppColors.error;
    else if (pct > 0.75) barColor = AppColors.warning;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Spend: \$${campaign.spend.toStringAsFixed(0)} / \$${campaign.budget.toStringAsFixed(0)}',
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary),
            ),
            Text(
              '${campaign.budgetUtilization.toStringAsFixed(0)}%',
              style: TextStyle(
                  fontSize: 11,
                  color: barColor,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 5,
            backgroundColor: AppColors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }

  Widget _metricChip(String label, String value) {
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

  Widget _typeIcon(CampaignType type) {
    IconData icon;
    Color color;
    switch (type) {
      case CampaignType.search:
        icon = Icons.search;
        color = AppColors.primary;
        break;
      case CampaignType.display:
        icon = Icons.image_outlined;
        color = AppColors.googleGreen;
        break;
      case CampaignType.video:
        icon = Icons.play_circle_outline;
        color = AppColors.googleRed;
        break;
      case CampaignType.shopping:
        icon = Icons.shopping_bag_outlined;
        color = AppColors.googleYellow;
        break;
      case CampaignType.smart:
        icon = Icons.auto_awesome;
        color = AppColors.primary;
        break;
    }
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.campaign_outlined, size: 64, color: AppColors.textHint),
          SizedBox(height: 12),
          Text('No campaigns found',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary)),
          SizedBox(height: 4),
          Text('Try adjusting your filters',
              style: TextStyle(fontSize: 13, color: AppColors.textHint)),
        ],
      ),
    );
  }

  String _formatNum(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }

  @override
  CampaignsViewModel viewModelBuilder(BuildContext context) =>
      CampaignsViewModel();

  @override
  void onViewModelReady(CampaignsViewModel viewModel) =>
      viewModel.initialise();
}