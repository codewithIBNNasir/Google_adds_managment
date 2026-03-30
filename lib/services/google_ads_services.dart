// lib/services/google_ads_service.dart

import 'dart:math';
import 'package:google_adds/UI/Campaigns/Campaign_model%20.dart';
import 'package:google_adds/services/Analytics_model.dart';
import 'package:google_adds/services/ad_models.dart';



class GoogleAdsService {
  final _random = Random();

  // Simulate API delay
  Future<void> _delay() async =>
      await Future.delayed(const Duration(milliseconds: 800));

  Future<GoogleAdsAccount> getAccount() async {
    await _delay();
    return const GoogleAdsAccount(
      customerId: '123-456-7890',
      name: 'My Business Account',
      currency: 'USD',
      timeZone: 'America/New_York',
      isMcc: false,
    );
  }

  Future<AccountSummary> getAccountSummary() async {
    await _delay();
    final now = DateTime.now();
    final metrics = List.generate(30, (i) {
      final date = now.subtract(Duration(days: 29 - i));
      return DailyMetric(
        date: date,
        spend: 150 + _random.nextDouble() * 350,
        impressions: 8000 + _random.nextInt(12000),
        clicks: 300 + _random.nextInt(500),
        conversions: 10 + _random.nextInt(40),
        ctr: 2.5 + _random.nextDouble() * 3.5,
        avgCpc: 0.45 + _random.nextDouble() * 1.2,
      );
    });

    return AccountSummary(
      totalSpend: 12450.80,
      totalBudget: 18000.00,
      totalImpressions: 284500,
      totalClicks: 9820,
      avgCtr: 3.45,
      avgCpc: 1.27,
      totalConversions: 743,
      conversionRate: 7.57,
      costPerConversion: 16.76,
      activeCampaigns: 5,
      pausedCampaigns: 2,
      last30Days: metrics,
    );
  }

  Future<List<CampaignModel>> getCampaigns() async {
    await _delay();
    return [
      CampaignModel(
        id: 'c1',
        name: 'Brand Awareness - Q1',
        status: CampaignStatus.active,
        type: CampaignType.search,
        budget: 5000,
        spend: 3845.20,
        impressions: 95400,
        clicks: 3120,
        ctr: 3.27,
        avgCpc: 1.23,
        conversions: 245,
        conversionRate: 7.85,
        startDate: DateTime(2024, 1, 1),
      ),
      CampaignModel(
        id: 'c2',
        name: 'Product Launch - Summer',
        status: CampaignStatus.active,
        type: CampaignType.display,
        budget: 3500,
        spend: 2910.60,
        impressions: 78200,
        clicks: 2450,
        ctr: 3.13,
        avgCpc: 1.19,
        conversions: 189,
        conversionRate: 7.71,
        startDate: DateTime(2024, 3, 15),
      ),
      CampaignModel(
        id: 'c3',
        name: 'Retargeting Campaign',
        status: CampaignStatus.active,
        type: CampaignType.smart,
        budget: 2000,
        spend: 1890.40,
        impressions: 42100,
        clicks: 1870,
        ctr: 4.44,
        avgCpc: 1.01,
        conversions: 198,
        conversionRate: 10.59,
        startDate: DateTime(2024, 2, 1),
      ),
      CampaignModel(
        id: 'c4',
        name: 'Video Ads - Brand',
        status: CampaignStatus.active,
        type: CampaignType.video,
        budget: 4000,
        spend: 2200.10,
        impressions: 52800,
        clicks: 1640,
        ctr: 3.11,
        avgCpc: 1.34,
        conversions: 87,
        conversionRate: 5.30,
        startDate: DateTime(2024, 1, 20),
      ),
      CampaignModel(
        id: 'c5',
        name: 'Shopping - Electronics',
        status: CampaignStatus.active,
        type: CampaignType.shopping,
        budget: 2500,
        spend: 1604.50,
        impressions: 16000,
        clicks: 740,
        ctr: 4.63,
        avgCpc: 2.17,
        conversions: 24,
        conversionRate: 3.24,
        startDate: DateTime(2024, 4, 1),
      ),
      CampaignModel(
        id: 'c6',
        name: 'Seasonal Promo - Old',
        status: CampaignStatus.paused,
        type: CampaignType.search,
        budget: 1500,
        spend: 1200.00,
        impressions: 22000,
        clicks: 890,
        ctr: 4.05,
        avgCpc: 1.35,
        conversions: 67,
        conversionRate: 7.53,
        startDate: DateTime(2023, 11, 1),
        endDate: DateTime(2024, 1, 15),
      ),
      CampaignModel(
        id: 'c7',
        name: 'App Install Campaign',
        status: CampaignStatus.paused,
        type: CampaignType.smart,
        budget: 1000,
        spend: 620.00,
        impressions: 14500,
        clicks: 560,
        ctr: 3.86,
        avgCpc: 1.11,
        conversions: 45,
        conversionRate: 8.04,
        startDate: DateTime(2024, 2, 10),
      ),
    ];
  }

  Future<List<AdGroupModel>> getAdGroups({String? campaignId}) async {
    await _delay();
    final allGroups = [
      AdGroupModel(
        id: 'ag1',
        campaignId: 'c1',
        name: 'Brand Keywords',
        status: AdGroupStatus.active,
        cpcBid: 1.50,
        impressions: 45200,
        clicks: 1520,
        ctr: 3.36,
        spend: 1840.00,
        conversions: 125,
      ),
      AdGroupModel(
        id: 'ag2',
        campaignId: 'c1',
        name: 'Competitor Keywords',
        status: AdGroupStatus.active,
        cpcBid: 2.00,
        impressions: 32100,
        clicks: 1100,
        ctr: 3.43,
        spend: 1450.00,
        conversions: 78,
      ),
      AdGroupModel(
        id: 'ag3',
        campaignId: 'c1',
        name: 'Generic Terms',
        status: AdGroupStatus.paused,
        cpcBid: 0.80,
        impressions: 18100,
        clicks: 500,
        ctr: 2.76,
        spend: 555.20,
        conversions: 42,
      ),
      AdGroupModel(
        id: 'ag4',
        campaignId: 'c2',
        name: 'Display - Remarketing',
        status: AdGroupStatus.active,
        cpcBid: 0.50,
        impressions: 48000,
        clicks: 1450,
        ctr: 3.02,
        spend: 1250.00,
        conversions: 112,
      ),
      AdGroupModel(
        id: 'ag5',
        campaignId: 'c2',
        name: 'Display - Interest',
        status: AdGroupStatus.active,
        cpcBid: 0.60,
        impressions: 30200,
        clicks: 1000,
        ctr: 3.31,
        spend: 1660.60,
        conversions: 77,
      ),
    ];

    if (campaignId != null) {
      return allGroups.where((g) => g.campaignId == campaignId).toList();
    }
    return allGroups;
  }

  Future<List<AdModel>> getAds({String? adGroupId}) async {
    await _delay();
    final allAds = [
      AdModel(
        id: 'a1',
        adGroupId: 'ag1',
        campaignId: 'c1',
        headline1: 'Best Products Online',
        headline2: 'Shop Now & Save Big',
        headline3: 'Free Shipping Over \$50',
        description1: 'Explore our top-rated products with amazing deals.',
        description2: 'Trusted by 10,000+ customers. Order today.',
        finalUrl: 'https://example.com/products',
        status: AdStatus.active,
        type: AdType.responsive,
        impressions: 28000,
        clicks: 950,
        ctr: 3.39,
        spend: 1140.00,
        conversions: 76,
        qualityScore: 8.5,
      ),
      AdModel(
        id: 'a2',
        adGroupId: 'ag1',
        campaignId: 'c1',
        headline1: 'Premium Quality Goods',
        headline2: 'Exclusive Deals Today',
        description1: 'Get the best deals on premium products.',
        finalUrl: 'https://example.com/deals',
        status: AdStatus.active,
        type: AdType.expandedText,
        impressions: 17200,
        clicks: 570,
        ctr: 3.31,
        spend: 700.00,
        conversions: 49,
        qualityScore: 7.8,
      ),
      AdModel(
        id: 'a3',
        adGroupId: 'ag2',
        campaignId: 'c1',
        headline1: 'Better Than The Competition',
        headline2: 'Why Choose Us',
        headline3: 'See The Difference',
        description1: 'Compare and discover why thousands prefer us.',
        finalUrl: 'https://example.com/compare',
        status: AdStatus.active,
        type: AdType.responsive,
        impressions: 22000,
        clicks: 780,
        ctr: 3.55,
        spend: 980.00,
        conversions: 58,
        qualityScore: 9.0,
      ),
      AdModel(
        id: 'a4',
        adGroupId: 'ag4',
        campaignId: 'c2',
        headline1: 'Welcome Back!',
        headline2: 'Special Offer Just For You',
        description1: 'Complete your purchase with an exclusive discount.',
        finalUrl: 'https://example.com/offer',
        status: AdStatus.active,
        type: AdType.display,
        impressions: 48000,
        clicks: 1450,
        ctr: 3.02,
        spend: 1250.00,
        conversions: 112,
        qualityScore: 8.2,
      ),
    ];

    if (adGroupId != null) {
      return allAds.where((a) => a.adGroupId == adGroupId).toList();
    }
    return allAds;
  }

  Future<bool> updateCampaignStatus(
      String campaignId, CampaignStatus status) async {
    await _delay();
    return true;
  }

  Future<bool> updateAdStatus(String adId, AdStatus status) async {
    await _delay();
    return true;
  }
}