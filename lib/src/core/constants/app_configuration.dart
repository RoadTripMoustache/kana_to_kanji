import 'package:envied/envied.dart';

part 'app_configuration.g.dart';

@Envied()
abstract class AppConfiguration {
  @EnviedField(varName: "API_URL")
  static const String apiUrl = _AppConfiguration.apiUrl;
}
