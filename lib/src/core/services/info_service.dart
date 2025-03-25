import "package:device_info_plus/device_info_plus.dart";
import "package:flutter/foundation.dart"
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import "package:flutter/services.dart";
import "package:package_info_plus/package_info_plus.dart";

/// Service that contains all device and package information
class InfoService {
  late final String appVersion;

  late final String appFullVersion;

  late final String appName;

  /// Name of the device the application is running on.
  ///
  /// For web, the browser name is returned.
  late final String devicePlatformName;

  /// Version of the platform the application is running on.
  /// For web, the browser name is returned
  late final String platformVersion;

  Future initialize() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    appVersion = packageInfo.version;
    appFullVersion = "$appVersion+${packageInfo.buildNumber}";
    appName = packageInfo.appName;

    if (kIsWeb) {
      await _buildWebDeviceInfo(deviceInfoPlugin);
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          await _buildAndroidDeviceInfo(deviceInfoPlugin);
        case TargetPlatform.iOS:
          await _buildIOSDeviceInfo(deviceInfoPlugin);
        // ignore: no_default_cases
        default:
          devicePlatformName = "N/A";
          platformVersion = "N/A";
      }
    }
  }

  Future _buildAndroidDeviceInfo(DeviceInfoPlugin deviceInfoPlugin) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      throw PlatformException(
        code: "INVALID PLATFORM",
        message: "Platform isn't android",
      );
    }
    final info = await deviceInfoPlugin.androidInfo;

    devicePlatformName = info.model;
    platformVersion = info.version.release;
  }

  Future _buildIOSDeviceInfo(DeviceInfoPlugin deviceInfoPlugin) async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      throw PlatformException(
        code: "INVALID PLATFORM",
        message: "Platform isn't iOS",
      );
    }
    final info = await deviceInfoPlugin.iosInfo;

    devicePlatformName = info.utsname.machine;
    platformVersion = info.systemVersion;
  }

  Future _buildWebDeviceInfo(DeviceInfoPlugin deviceInfoPlugin) async {
    if (!kIsWeb) {
      throw PlatformException(
        code: "INVALID PLATFORM",
        message: "Platform isn't Web",
      );
    }
    final info = await deviceInfoPlugin.webBrowserInfo;

    devicePlatformName = info.browserName.name;
    platformVersion = info.productSub ?? "N/A";
  }
}
