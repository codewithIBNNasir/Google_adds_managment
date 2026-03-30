// lib/ui/views/reports/reports_view.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_adds/UI/Theme/apptheme.dart';
import 'package:google_adds/UI/dashboard/dashboard_view.dart';
import 'package:google_adds/UI/reports/reports_view_model.dart';
import 'package:google_adds/UI/widgets/loading_overlay.dart';
import 'package:google_adds/services/Analytics_model.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class ReportsView extends StackedView<ReportsViewModel> {
  const ReportsView({super.key});

  @override
  Widget builder(
      BuildContext context, ReportsViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {},
            tooltip: 'Export',
          ),
        ],
      ),
      body: viewModel.isBusy
          ? const LoadingOverlay()
          : RefreshIndicator(
              onRefresh: viewModel.refresh,
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMetricSelector(viewModel),
                    const SizedBox(height: 16),
                    _buildChart(viewModel),
                    const SizedBox(height: 20),
                    if (viewModel.summary != null)
                      _buildSummaryStats(viewModel.summary!),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMetricSelector(ReportsViewModel vm) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Metric',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            Row(
              children: vm.metrics.map((m) {
                final isSelected = vm.selectedMetric == m;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => vm.setMetric(m),
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.divider,
                        ),
                      ),
                      child: Text(
                        m[0].toUpperCase() + m.substring(1),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(ReportsViewModel vm) {
    final data = vm.chartData;
    if (data.isEmpty) return const SizedBox.shrink();

    final values = data.map(vm.metricValue).toList();
    final maxVal = values.reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${vm.selectedMetric[0].toUpperCase()}${vm.selectedMetric.substring(1)} — Last 30 Days',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  maxY: maxVal * 1.2,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxVal / 4,
                    getDrawingHorizontalLine: (v) => const FlLine(
                        color: AppColors.divider, strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 48,
                        getTitlesWidget: (value, meta) {
                          String label;
                          if (vm.selectedMetric == 'spend') {
                            label = '\$${(value / 1000).toStringAsFixed(1)}K';
                          } else if (value >= 1000) {
                            label = '${(value / 1000).toStringAsFixed(1)}K';
                          } else {
                            label = value.toInt().toString();
                          }
                          return Text(label,
                              style: const TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textSecondary));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 7,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx >= 0 && idx < data.length) {
                            return Text(
                              DateFormat('MMM d').format(data[idx].date),
                              style: const TextStyle(
                                  fontSize: 9,
                                  color: AppColors.textSecondary),
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
                  barGroups: List.generate(
                    data.length,
                    (i) => BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: values[i],
                          color: AppColors.primary,
                          width: 6,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(3)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStats(AccountSummary s) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('30-Day Summary',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 14),
            _summaryRow('Total Spend',
                '\$${s.totalSpend.toStringAsFixed(2)}', AppColors.primary),
            _summaryRow('Total Impressions',
                _fmt(s.totalImpressions), AppColors.googleGreen),
            _summaryRow('Total Clicks', _fmt(s.totalClicks), AppColors.googleYellow),
            _summaryRow('Avg CTR', '${s.avgCtr.toStringAsFixed(2)}%', AppColors.googleRed),
            _summaryRow('Avg CPC', '\$${s.avgCpc.toStringAsFixed(2)}', AppColors.primary),
            _summaryRow('Conversions', '${s.totalConversions}', AppColors.googleGreen),
            _summaryRow('Conv. Rate', '${s.conversionRate.toStringAsFixed(2)}%', AppColors.googleYellow),
            _summaryRow('Cost / Conv.', '\$${s.costPerConversion.toStringAsFixed(2)}', AppColors.googleRed),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
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
  ReportsViewModel viewModelBuilder(BuildContext context) => ReportsViewModel();

  @override
  void onViewModelReady(ReportsViewModel viewModel) => viewModel.initialise();
}