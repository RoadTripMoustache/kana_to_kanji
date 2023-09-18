import 'package:package_info_plus/package_info_plus.dart';

/// Service that contains all device and package information
class InfoService {
  late final String appVersion;

  late final String appName;

  Future initialize() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    appVersion = packageInfo.version;
    appName = packageInfo.appName;
  }
}
