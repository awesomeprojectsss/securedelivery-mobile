import 'package:securedelivery_mobile/app/environment/app_environment.dart';
import 'package:securedelivery_mobile/app/environment/development_environment.dart';
import 'package:securedelivery_mobile/app/environment/production_environment.dart';
import 'package:securedelivery_mobile/app/environment/staging_environment.dart';

const _environmentName = String.fromEnvironment(
  'APP_ENV',
  defaultValue: 'development',
);

AppEnvironment get currentEnvironment {
  switch (_environmentName) {
    case 'development':
      return developmentEnvironment;
    case 'staging':
      return stagingEnvironment;
    case 'production':
      return productionEnvironment;
    default:
      throw UnsupportedError('Unsupported APP_ENV: $_environmentName');
  }
}
