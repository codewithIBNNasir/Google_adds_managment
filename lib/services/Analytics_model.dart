

class DailyMetric {
  final DateTime date;
  final double spend;
  final int impressions;
  final int clicks;
  final int conversions;
  final double ctr;
  final double avgCpc;

  const DailyMetric({
    required this.date,
    required this.spend,
    required this.impressions,
    required this.clicks,
    required this.conversions,
    required this.ctr,
    required this.avgCpc,
  });
}

class AccountSummary {
  final double totalSpend;
  final double totalBudget;
  final int totalImpressions;
  final int totalClicks;
  final double avgCtr;
  final double avgCpc;
  final int totalConversions;
  final double conversionRate;
  final double costPerConversion;
  final int activeCampaigns;
  final int pausedCampaigns;
  final List<DailyMetric> last30Days;

  const AccountSummary({
    required this.totalSpend,
    required this.totalBudget,
    required this.totalImpressions,
    required this.totalClicks,
    required this.avgCtr,
    required this.avgCpc,
    required this.totalConversions,
    required this.conversionRate,
    required this.costPerConversion,
    required this.activeCampaigns,
    required this.pausedCampaigns,
    required this.last30Days,
  });
}

// lib/models/account_model.dart

class GoogleAdsAccount {
  final String customerId;
  final String name;
  final String currency;
  final String timeZone;
  final bool isMcc;

  const GoogleAdsAccount({
    required this.customerId,
    required this.name,
    required this.currency,
    required this.timeZone,
    required this.isMcc,
  });
}