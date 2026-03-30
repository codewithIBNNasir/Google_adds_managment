// lib/app/app.router.dart (manually written, no code gen needed)

import 'package:flutter/material.dart';
import 'package:google_adds/UI/Campaigns/Campaign_model%20.dart';
import 'package:google_adds/UI/Campaigns/Campaigns_detail_view.dart';
import 'package:google_adds/UI/Campaigns/Campaigns_view.dart';
import 'package:google_adds/UI/dashboard/dashboard_view.dart';
import 'package:google_adds/UI/reports/reports_view.dart';
import 'package:google_adds/UI/views/ads%20group/ads_group_view.dart';
import 'package:google_adds/UI/views/ads/ads_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';


const String dashboardRoute = '/dashboard';
const String campaignsRoute = '/campaigns';
const String campaignDetailRoute = '/campaigns/detail';
const String adGroupsRoute = '/ad-groups';
const String adsRoute = '/ads';
const String reportsRoute = '/reports';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboardRoute:
        return MaterialPageRoute(builder: (_) => const DashboardView());
      case campaignsRoute:
        return MaterialPageRoute(builder: (_) => const CampaignsView());
      case campaignDetailRoute:
        final campaign = settings.arguments as CampaignModel;
        return MaterialPageRoute(
            builder: (_) => CampaignDetailView(campaign: campaign));
      case adGroupsRoute:
        return MaterialPageRoute(builder: (_) => const AdGroupsView());
      case adsRoute:
        return MaterialPageRoute(builder: (_) => const AdsView());
      case reportsRoute:
        return MaterialPageRoute(builder: (_) => const ReportsView());
      default:
        return MaterialPageRoute(builder: (_) => const DashboardView());
    }
  }
}