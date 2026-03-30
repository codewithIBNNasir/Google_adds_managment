// lib/ui/views/ad_groups/ad_groups_viewmodel.dart

import 'package:google_adds/App/locatore.dart';
import 'package:google_adds/services/ad_models.dart';
import 'package:google_adds/services/google_ads_services.dart';
import 'package:stacked/stacked.dart';


class AdGroupsViewModel extends BaseViewModel {
  final _adsService = locator<GoogleAdsService>();

  List<AdGroupModel> _adGroups = [];
  List<AdGroupModel> get adGroups => _adGroups;

  Future<void> initialise() async {
    await runBusyFuture(_load());
  }

  Future<void> _load() async {
    _adGroups = await _adsService.getAdGroups();
    rebuildUi();
  }

  Future<void> refresh() async => runBusyFuture(_load());
}