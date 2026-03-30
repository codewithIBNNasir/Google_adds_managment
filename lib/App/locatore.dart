// lib/app/locator.dart

import 'package:get_it/get_it.dart';
import 'package:google_adds/services/google_ads_services.dart';


final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<GoogleAdsService>(() => GoogleAdsService());
}