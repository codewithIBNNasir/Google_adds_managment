import 'package:google_adds/App/locatore.dart';
import 'package:google_adds/UI/Campaigns/Campaign_model%20.dart';
import 'package:google_adds/services/google_ads_services.dart';
import 'package:stacked/stacked.dart';


class CampaignsViewModel extends BaseViewModel {
  final _adsService = locator<GoogleAdsService>();

  List<CampaignModel> _allCampaigns = [];
  List<CampaignModel> _filteredCampaigns = [];
  List<CampaignModel> get campaigns => _filteredCampaigns;

  CampaignStatus? _statusFilter;
  CampaignStatus? get statusFilter => _statusFilter;

  CampaignType? _typeFilter;
  CampaignType? get typeFilter => _typeFilter;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _sortBy = 'spend';
  String get sortBy => _sortBy;

  final sortOptions = ['spend', 'clicks', 'impressions', 'ctr', 'name'];

  Future<void> initialise() async {
    await runBusyFuture(_loadCampaigns());
  }

  Future<void> _loadCampaigns() async {
    _allCampaigns = await _adsService.getCampaigns();
    _applyFilters();
    rebuildUi();
  }

  void _applyFilters() {
    var filtered = List<CampaignModel>.from(_allCampaigns);

    if (_statusFilter != null) {
      filtered = filtered.where((c) => c.status == _statusFilter).toList();
    }

    if (_typeFilter != null) {
      filtered = filtered.where((c) => c.type == _typeFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((c) =>
              c.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    switch (_sortBy) {
      case 'spend':
        filtered.sort((a, b) => b.spend.compareTo(a.spend));
        break;
      case 'clicks':
        filtered.sort((a, b) => b.clicks.compareTo(a.clicks));
        break;
      case 'impressions':
        filtered.sort((a, b) => b.impressions.compareTo(a.impressions));
        break;
      case 'ctr':
        filtered.sort((a, b) => b.ctr.compareTo(a.ctr));
        break;
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    _filteredCampaigns = filtered;
  }

  void setStatusFilter(CampaignStatus? status) {
    _statusFilter = status;
    _applyFilters();
    notifyListeners();
  }

  void setTypeFilter(CampaignType? type) {
    _typeFilter = type;
    _applyFilters();
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    _applyFilters();
    notifyListeners();
  }

  Future<void> toggleCampaignStatus(CampaignModel campaign) async {
    final newStatus = campaign.status == CampaignStatus.active
        ? CampaignStatus.paused
        : CampaignStatus.active;
    await _adsService.updateCampaignStatus(campaign.id, newStatus);
    await _loadCampaigns();
  }

  Future<void> refresh() async {
    await runBusyFuture(_loadCampaigns());
  }

  int get activeCampaignsCount =>
      _allCampaigns.where((c) => c.status == CampaignStatus.active).length;

  int get pausedCampaignsCount =>
      _allCampaigns.where((c) => c.status == CampaignStatus.paused).length;

  double get totalSpend =>
      _allCampaigns.fold(0, (sum, c) => sum + c.spend);
}