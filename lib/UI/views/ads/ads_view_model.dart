import 'package:google_adds/App/locatore.dart';
import 'package:google_adds/services/ad_models.dart';
import 'package:google_adds/services/google_ads_services.dart';
import 'package:stacked/stacked.dart';


class AdsViewModel extends BaseViewModel {
  final _adsService = locator<GoogleAdsService>();

  List<AdModel> _ads = [];
  List<AdModel> get ads => _ads;

  Future<void> initialise() async {
    await runBusyFuture(_load());
  }

  Future<void> _load() async {
    _ads = await _adsService.getAds();
    rebuildUi();
  }

  Future<void> refresh() async => runBusyFuture(_load());

  Future<void> toggleAdStatus(AdModel ad) async {
    final newStatus = ad.status == AdStatus.active
        ? AdStatus.paused
        : AdStatus.active;
    await _adsService.updateAdStatus(ad.id, newStatus);
    await _load();
  }
}