import 'package:flutter/material.dart';
import 'package:google_adds/UI/Theme/apptheme.dart';
import 'package:google_adds/UI/views/ads/ads_view_model.dart';
import 'package:google_adds/UI/widgets/loading_overlay.dart';
import 'package:google_adds/services/ad_models.dart';
import 'package:stacked/stacked.dart';

class AdsView extends StackedView<AdsViewModel> {
  const AdsView({super.key});

  @override
  Widget builder(
      BuildContext context, AdsViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ads'),
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
                itemCount: viewModel.ads.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) =>
                    _buildAdCard(viewModel.ads[i], viewModel),
              ),
            ),
    );
  }

  Widget _buildAdCard(AdModel ad, AdsViewModel vm) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAdPreview(ad),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statusChip(ad.status),
                    Row(
                      children: [
                        _qualityScoreBadge(ad.qualityScore),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => vm.toggleAdStatus(ad),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: ad.status == AdStatus.active
                                  ? AppColors.errorLight
                                  : AppColors.secondaryLight,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              ad.status == AdStatus.active
                                  ? 'Pause'
                                  : 'Enable',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: ad.status == AdStatus.active
                                      ? AppColors.error
                                      : AppColors.secondary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _stat('Impressions', _fmt(ad.impressions)),
                    _stat('Clicks', _fmt(ad.clicks)),
                    _stat('CTR', '${ad.ctr.toStringAsFixed(2)}%'),
                    _stat('Conv.', '${ad.conversions}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdPreview(AdModel ad) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.googleBlue,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(Icons.g_mobiledata,
                    color: Colors.white, size: 14),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ad.finalUrl,
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.googleGreen),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            [ad.headline1, ad.headline2, if (ad.headline3 != null) ad.headline3!]
                .join(' | '),
            style: const TextStyle(
                fontSize: 15,
                color: AppColors.googleBlue,
                fontWeight: FontWeight.w500),
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          Text(
            ad.description1,
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _statusChip(AdStatus status) {
    Color color;
    String label;
    switch (status) {
      case AdStatus.active:
        color = AppColors.secondary;
        label = 'Active';
        break;
      case AdStatus.paused:
        color = AppColors.warning;
        label = 'Paused';
        break;
      case AdStatus.disapproved:
        color = AppColors.error;
        label = 'Disapproved';
        break;
      default:
        color = AppColors.textSecondary;
        label = status.name;
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
            width: 6,
            height: 6,
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

  Widget _qualityScoreBadge(double score) {
    Color color;
    if (score >= 8) color = AppColors.secondary;
    else if (score >= 6) color = AppColors.warning;
    else color = AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'QS: ${score.toStringAsFixed(1)}',
        style: TextStyle(
            fontSize: 11, color: color, fontWeight: FontWeight.w600),
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
  AdsViewModel viewModelBuilder(BuildContext context) => AdsViewModel();

  @override
  void onViewModelReady(AdsViewModel viewModel) => viewModel.initialise();
}