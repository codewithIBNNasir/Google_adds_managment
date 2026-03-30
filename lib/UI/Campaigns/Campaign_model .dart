
enum CampaignStatus { active, paused, removed, ended }

enum CampaignType { search, display, video, shopping, smart }

class CampaignModel {
  final String id;
  final String name;
  final CampaignStatus status;
  final CampaignType type;
  final double budget;
  final double spend;
  final int impressions;
  final int clicks;
  final double ctr;
  final double avgCpc;
  final int conversions;
  final double conversionRate;
  final DateTime startDate;
  final DateTime? endDate;

  const CampaignModel({
    required this.id,
    required this.name,
    required this.status,
    required this.type,
    required this.budget,
    required this.spend,
    required this.impressions,
    required this.clicks,
    required this.ctr,
    required this.avgCpc,
    required this.conversions,
    required this.conversionRate,
    required this.startDate,
    this.endDate,
  });

  double get budgetUtilization => budget > 0 ? (spend / budget) * 100 : 0;

  String get statusLabel {
    switch (status) {
      case CampaignStatus.active:
        return 'Active';
      case CampaignStatus.paused:
        return 'Paused';
      case CampaignStatus.removed:
        return 'Removed';
      case CampaignStatus.ended:
        return 'Ended';
    }
  }

  String get typeLabel {
    switch (type) {
      case CampaignType.search:
        return 'Search';
      case CampaignType.display:
        return 'Display';
      case CampaignType.video:
        return 'Video';
      case CampaignType.shopping:
        return 'Shopping';
      case CampaignType.smart:
        return 'Smart';
    }
  }
}