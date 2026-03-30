import 'package:flutter/material.dart';
import 'package:google_adds/UI/Campaigns/Campaign_model%20.dart';
import 'package:google_adds/UI/Campaigns/Campaigns_detail_view_model.dart';
import 'package:google_adds/UI/Theme/apptheme.dart';
import 'package:google_adds/UI/widgets/Campaign_status_badge.dart';
import 'package:google_adds/UI/widgets/loading_overlay.dart';
import 'package:google_adds/services/ad_models.dart';
import 'package:stacked/stacked.dart';

class CampaignDetailView extends StackedView<CampaignDetailViewModel> {
  final CampaignModel campaign;
  const CampaignDetailView({super.key, required this.campaign});

  @override
  Widget builder(BuildContext context, CampaignDetailViewModel vm,
      Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(campaign.name,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: vm.isBusy
          ? const LoadingOverlay()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCampaignHeader(campaign, vm),
                  const SizedBox(height: 16),
                  _buildMetrics(campaign, vm),
                  const SizedBox(height: 16),
                  _buildAdGroups(vm),
                ],
              ),
            ),
    );
  }

  Widget _buildCampaignHeader(CampaignModel c, CampaignDetailViewModel vm) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(c.name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                ),
                CampaignStatusBadge(status: c.status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _infoChip(c.typeLabel, Icons.campaign_outlined),
                const SizedBox(width: 8),
                _infoChip('Daily Budget: ${vm.formatCurrency(c.budget)}',
                    Icons.account_balance_wallet_outlined),
              ],
            ),
            const SizedBox(height: 12),
            _buildBudgetProgress(c),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildBudgetProgress(CampaignModel c) {
    final pct = (c.budgetUtilization / 100).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Spent \$${c.spend.toStringAsFixed(2)} of \$${c.budget.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
            Text('${c.budgetUtilization.toStringAsFixed(1)}%',
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 6,
            backgroundColor: AppColors.divider,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildMetrics(CampaignModel c, CampaignDetailViewModel vm) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: [
        _metricTile('Impressions', _fmt(c.impressions), Icons.visibility_outlined, AppColors.primary),
        _metricTile('Clicks', _fmt(c.clicks), Icons.touch_app_outlined, AppColors.googleGreen),
        _metricTile('CTR', '${c.ctr.toStringAsFixed(2)}%', Icons.percent, AppColors.googleYellow),
        _metricTile('Avg CPC', '\$${c.avgCpc.toStringAsFixed(2)}', Icons.attach_money, AppColors.googleRed),
        _metricTile('Conversions', '${c.conversions}', Icons.track_changes_outlined, AppColors.primary),
        _metricTile('Conv. Rate', '${c.conversionRate.toStringAsFixed(1)}%', Icons.trending_up, AppColors.googleGreen),
      ],
    );
  }

  Widget _metricTile(
      String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                Text(label,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdGroups(CampaignDetailViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Ad Groups',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (vm.adGroups.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text('No ad groups in this campaign',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
            ),
          )
        else
          Card(
            child: Column(
              children: List.generate(vm.adGroups.length, (i) {
                final ag = vm.adGroups[i];
                final isLast = i == vm.adGroups.length - 1;
                return Column(
                  children: [
                    _adGroupRow(ag),
                    if (!isLast) const Divider(height: 1),
                  ],
                );
              }),
            ),
          ),
      ],
    );
  }

  Widget _adGroupRow(AdGroupModel ag) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: ag.status == AdGroupStatus.active
                  ? AppColors.secondary
                  : AppColors.warning,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ag.name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary)),
                Text('Bid: \$${ag.cpcBid.toStringAsFixed(2)} CPC',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${ag.clicks} clicks',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary)),
              Text('${ag.conversions} conv.',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }

  @override
  CampaignDetailViewModel viewModelBuilder(BuildContext context) =>
      CampaignDetailViewModel(campaign: campaign);

  @override
  void onViewModelReady(CampaignDetailViewModel viewModel) =>
      viewModel.initialise();
}