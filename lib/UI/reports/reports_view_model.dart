// lib/ui/views/reports/reports_viewmodel.dart


import 'package:google_adds/App/locatore.dart';
import 'package:google_adds/services/Analytics_model.dart';
import 'package:google_adds/services/google_ads_services.dart';
import 'package:stacked/stacked.dart';


class ReportsViewModel extends BaseViewModel {
  final _adsService = locator<GoogleAdsService>();

  AccountSummary? _summary;
  AccountSummary? get summary => _summary;

  String _selectedMetric = 'spend';
  String get selectedMetric => _selectedMetric;

  final metrics = ['spend', 'clicks', 'impressions', 'conversions'];

  Future<void> initialise() async {
    await runBusyFuture(_load());
  }

  Future<void> _load() async {
    _summary = await _adsService.getAccountSummary();
    rebuildUi();
  }

  void setMetric(String metric) {
    _selectedMetric = metric;
    notifyListeners();
  }

  Future<void> refresh() async => runBusyFuture(_load());

  List<DailyMetric> get chartData => _summary?.last30Days ?? [];

  double metricValue(DailyMetric m) {
    switch (_selectedMetric) {
      case 'spend':
        return m.spend;
      case 'clicks':
        return m.clicks.toDouble();
      case 'impressions':
        return m.impressions.toDouble();
      case 'conversions':
        return m.conversions.toDouble();
      default:
        return m.spend;
    }
  }
}