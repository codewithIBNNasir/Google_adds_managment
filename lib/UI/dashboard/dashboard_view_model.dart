// lib/ui/views/dashboard/dashboard_viewmodel.dart

import 'package:google_adds/App/locatore.dart';
import 'package:google_adds/UI/Campaigns/Campaign_model%20.dart';
import 'package:google_adds/services/Analytics_model.dart';
import 'package:google_adds/services/google_ads_services.dart';
import 'package:stacked/stacked.dart';


class DashboardViewModel extends BaseViewModel {
  final _adsService = locator<GoogleAdsService>();

  AccountSummary? _summary;
  AccountSummary? get summary => _summary;

  GoogleAdsAccount? _account;
  GoogleAdsAccount? get account => _account;

  List<CampaignModel> _topCampaigns = [];
  List<CampaignModel> get topCampaigns => _topCampaigns;

  String _selectedPeriod = '30d';
  String get selectedPeriod => _selectedPeriod;

  final periods = ['7d', '14d', '30d', '90d'];

  Future<void> initialise() async {
    await runBusyFuture(_loadData());
  }

  Future<void> _loadData() async {
    final results = await Future.wait([
      _adsService.getAccount(),
      _adsService.getAccountSummary(),
      _adsService.getCampaigns(),
    ]);

    _account = results[0] as GoogleAdsAccount;
    _summary = results[1] as AccountSummary;
    final campaigns = results[2] as List<CampaignModel>;
    _topCampaigns = campaigns
        .where((c) => c.status == CampaignStatus.active)
        .take(4)
        .toList();
    rebuildUi();
  }

  void setPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  Future<void> refresh() async {
    await runBusyFuture(_loadData());
  }

  String formatCurrency(double value) {
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}K';
    }
    return '\$${value.toStringAsFixed(2)}';
  }

  String formatNumber(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}