import 'package:envied/envied.dart';

part 'app_env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class AppEnv {
  @EnviedField(varName: 'UNITY_APP_KEY_ANDROID')
  static final String unityAppKeyAndroid = _AppEnv.unityAppKeyAndroid;
}
