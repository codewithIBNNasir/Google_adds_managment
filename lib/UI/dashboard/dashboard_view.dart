// lib/ui/views/dashboard/dashboard_view.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_adds/UI/Campaigns/Campaign_model%20.dart';
import 'package:google_adds/UI/Theme/apptheme.dart';
import 'package:google_adds/UI/dashboard/dashboard_view_model.dart';
import 'package:google_adds/UI/widgets/Campaign_status_badge.dart';
import 'package:google_adds/UI/widgets/loading_overlay.dart';
import 'package:google_adds/UI/widgets/metriccard.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';


class DashboardView extends StackedView<DashboardViewModel> {
  const DashboardView({super.key});

  @override
  Widget builder(
      BuildContext context, DashboardViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, viewModel),
      body: viewModel.isBusy
          ? const LoadingOverlay()
          : RefreshIndicator(
              onRefresh: viewModel.refresh,
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppConstants.kPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (viewModel.summary != null) ...[
                      _buildPeriodSelector(viewModel),
                      const SizedBox(height: 16),
                      _buildMetricsGrid(context, viewModel),
                      const SizedBox(height: 20),
                      _buildSpendChart(context, viewModel),
                      const SizedBox(height: 20),
                      _buildCampaignBudgetOverview(context, viewModel),
                      const SizedBox(height: 20),
                      _buildTopCampaigns(context, viewModel),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  AppBar _buildAppBar(BuildContext context, DashboardViewModel vm) {
    return AppBar(
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.ads_click,
                color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Google Ads Manager',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              if (vm.account != null)
                Text(vm.account!.customerId,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
          tooltip: 'Notifications',
        ),
        const SizedBox(width: 4),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: const Text('A',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector(DashboardViewModel vm) {
    return Row(
      children: [
        const Text('Overview',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: vm.periods.map((p) {
              final isSelected = vm.selectedPeriod == p;
              return GestureDetector(
                onTap: () => vm.setPeriod(p),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(p,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(
      BuildContext context, DashboardViewModel viewModel) {
    final s = viewModel.summary!;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: [
        MetricCard(
          label: 'Total Spend',
          value: viewModel.formatCurrency(s.totalSpend),
          subValue: 'Budget: ${viewModel.formatCurrency(s.totalBudget)}',
          icon: Icons.attach_money,
          iconColor: AppColors.primary,
          iconBg: AppColors.primaryLight,
          trend: 12.4,
        ),
        MetricCard(
          label: 'Impressions',
          value: viewModel.formatNumber(s.totalImpressions),
          subValue: 'CTR: ${s.avgCtr.toStringAsFixed(2)}%',
          icon: Icons.visibility_outlined,
          iconColor: AppColors.googleGreen,
          iconBg: AppColors.secondaryLight,
          trend: 8.7,
        ),
        MetricCard(
          label: 'Clicks',
          value: viewModel.formatNumber(s.totalClicks),
          subValue: 'Avg CPC: \$${s.avgCpc.toStringAsFixed(2)}',
          icon: Icons.touch_app_outlined,
          iconColor: AppColors.googleYellow,
          iconBg: AppColors.warningLight,
          trend: -2.3,
        ),
        MetricCard(
          label: 'Conversions',
          value: viewModel.formatNumber(s.totalConversions),
          subValue: 'Rate: ${s.conversionRate.toStringAsFixed(1)}%',
          icon: Icons.track_changes_outlined,
          iconColor: AppColors.googleRed,
          iconBg: AppColors.errorLight,
          trend: 15.2,
        ),
      ],
    );
  }

  Widget _buildSpendChart(BuildContext context, DashboardViewModel vm) {
    final metrics = vm.summary!.last30Days;
    final maxSpend =
        metrics.map((m) => m.spend).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Spend Over Time',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Last 30 days',
                      style: TextStyle(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 160,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxSpend / 4,
                    getDrawingHorizontalLine: (v) => const FlLine(
                        color: AppColors.divider, strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        getTitlesWidget: (value, meta) => Text(
                          '\$${(value / 1000).toStringAsFixed(1)}K',
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 7,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx >= 0 && idx < metrics.length) {
                            return Text(
                              DateFormat('MMM d').format(metrics[idx].date),
                              style: const TextStyle(
                                  fontSize: 10, color: AppColors.textSecondary),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        metrics.length,
                        (i) => FlSpot(i.toDouble(), metrics[i].spend),
                      ),
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 2.5,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primary.withOpacity(0.08),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampaignBudgetOverview(
      BuildContext context, DashboardViewModel vm) {
    final s = vm.summary!;
    final utilized = s.totalSpend / s.totalBudget;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Budget Overview',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBudgetStat(
                    'Total Budget', vm.formatCurrency(s.totalBudget)),
                _buildBudgetStat('Spent', vm.formatCurrency(s.totalSpend)),
                _buildBudgetStat(
                    'Remaining',
                    vm.formatCurrency(s.totalBudget - s.totalSpend),
                    isGreen: true),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: utilized,
                minHeight: 8,
                backgroundColor: AppColors.divider,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(utilized * 100).toStringAsFixed(1)}% of budget utilized',
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildCampaignCountBadge(
                    s.activeCampaigns, 'Active', AppColors.secondary),
                const SizedBox(width: 8),
                _buildCampaignCountBadge(
                    s.pausedCampaigns, 'Paused', AppColors.warning),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetStat(String label, String value,
      {bool isGreen = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 2),
        Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isGreen ? AppColors.secondary : AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildCampaignCountBadge(int count, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text('$count $label',
              style: TextStyle(
                  fontSize: 12, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTopCampaigns(
      BuildContext context, DashboardViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Top Campaigns',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/campaigns'),
              child: const Text('View All',
                  style: TextStyle(
                      fontSize: 13, color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: List.generate(
              viewModel.topCampaigns.length,
              (i) {
                final c = viewModel.topCampaigns[i];
                final isLast = i == viewModel.topCampaigns.length - 1;
                return Column(
                  children: [
                    _buildCampaignRow(c, viewModel),
                    if (!isLast) const Divider(height: 1),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCampaignRow(CampaignModel c, DashboardViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _campaignTypeIcon(c.type),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(c.typeLabel,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(vm.formatCurrency(c.spend),
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text('${c.ctr.toStringAsFixed(2)}% CTR',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(width: 8),
          CampaignStatusBadge(status: c.status),
        ],
      ),
    );
  }

  Widget _campaignTypeIcon(CampaignType type) {
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
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) =>
      DashboardViewModel();

  @override
  void onViewModelReady(DashboardViewModel viewModel) =>
      viewModel.initialise();
}