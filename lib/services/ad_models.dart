// lib/models/ad_group_model.dart

enum AdGroupStatus { active, paused, removed }

class AdGroupModel {
  final String id;
  final String campaignId;
  final String name;
  final AdGroupStatus status;
  final double cpcBid;
  final int impressions;
  final int clicks;
  final double ctr;
  final double spend;
  final int conversions;

  const AdGroupModel({
    required this.id,
    required this.campaignId,
    required this.name,
    required this.status,
    required this.cpcBid,
    required this.impressions,
    required this.clicks,
    required this.ctr,
    required this.spend,
    required this.conversions,
  });
}

// lib/models/ad_model.dart

enum AdStatus { active, paused, removed, underReview, approved, disapproved }

enum AdType { expandedText, responsive, display, video, call }

class AdModel {
  final String id;
  final String adGroupId;
  final String campaignId;
  final String headline1;
  final String headline2;
  final String? headline3;
  final String description1;
  final String? description2;
  final String finalUrl;
  final AdStatus status;
  final AdType type;
  final int impressions;
  final int clicks;
  final double ctr;
  final double spend;
  final int conversions;
  final double qualityScore;

  const AdModel({
    required this.id,
    required this.adGroupId,
    required this.campaignId,
    required this.headline1,
    required this.headline2,
    this.headline3,
    required this.description1,
    this.description2,
    required this.finalUrl,
    required this.status,
    required this.type,
    required this.impressions,
    required this.clicks,
    required this.ctr,
    required this.spend,
    required this.conversions,
    required this.qualityScore,
  });

  String get statusLabel {
    switch (status) {
      case AdStatus.active:
        return 'Active';
      case AdStatus.paused:
        return 'Paused';
      case AdStatus.removed:
        return 'Removed';
      case AdStatus.underReview:
        return 'Under Review';
      case AdStatus.approved:
        return 'Approved';
      case AdStatus.disapproved:
        return 'Disapproved';
    }
  }
}