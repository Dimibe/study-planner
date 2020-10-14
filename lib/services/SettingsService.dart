import 'package:get_it/get_it.dart';
import 'package:study_planner/models/Settings.dart';

import 'Cache.dart';
import 'FirestoreService.dart';
import 'StorageService.dart';
import 'UserService.dart';

final getIt = GetIt.instance;

class SettingsService {
  SettingsService();

  Future<Settings> loadSettings({bool force = false}) async {
    if (!force && getIt<Cache>().settings != null) {
      return getIt<Cache>().settings;
    }
    Settings settings;
    if (getIt<UserService>().isLoggedIn) {
      var userService = getIt<UserService>();
      var uid = userService.getUid();
      var document = getIt<FirestoreService>().getDocument('settings', uid);
      var json = (await document).data();
      if (json == null) {
        settings = Settings();
      }
      settings = Settings.fromJson(json);
    } else {
      settings = getIt<StorageService>().loadSettings();
    }
    getIt<Cache>().settings = settings;
    return settings;
  }

  Future<void> saveSettings(Settings settings) {
    getIt<Cache>().settings = settings;
    if (getIt<UserService>().isLoggedIn) {
      var uid = getIt<UserService>().getUid();
      return getIt<FirestoreService>()
          .saveDocument('settings', uid, settings.toJson());
    } else {
      return getIt<StorageService>().saveSettings(settings);
    }
  }
}
