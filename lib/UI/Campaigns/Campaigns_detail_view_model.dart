// lib/ui/views/campaigns/campaign_detail_viewmodel.dart

import 'package:google_adds/App/locatore.dart';
import 'package:google_adds/UI/Campaigns/Campaign_model%20.dart';
import 'package:google_adds/services/ad_models.dart';
import 'package:google_adds/services/google_ads_services.dart';
import 'package:stacked/stacked.dart';


class CampaignDetailViewModel extends BaseViewModel {
  final _adsService = locator<GoogleAdsService>();
  final CampaignModel campaign;

  CampaignDetailViewModel({required this.campaign});

  List<AdGroupModel> _adGroups = [];
  List<AdGroupModel> get adGroups => _adGroups;

  Future<void> initialise() async {
    await runBusyFuture(_loadData());
  }

  Future<void> _loadData() async {
    _adGroups = await _adsService.getAdGroups(campaignId: campaign.id);
    rebuildUi();
  }

  String formatCurrency(double v) =>
      v >= 1000 ? '\$${(v / 1000).toStringAsFixed(1)}K' : '\$${v.toStringAsFixed(2)}';
}

// lib/ui/views/campaigns/campaign_detail_view.dart