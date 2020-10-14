import 'package:get_it/get_it.dart';
import 'package:study_planner/models/Settings.dart';

import 'FirestoreService.dart';
import 'StorageService.dart';
import 'UserService.dart';

class SettingsService {
  Future<Settings> loadSettings() async {
    if (GetIt.I<UserService>().isLoggedIn) {
      var userService = GetIt.I<UserService>();
      var uid = userService.getUid();
      var document = GetIt.I<FirestoreService>().getDocument('settings', uid);
      var json = (await document).data();
      if (json == null) {
        return Settings();
      }
      return Settings.fromJson(json);
    } else {
      return GetIt.I<StorageService>().loadSettings();
    }
  }

  Future<void> saveSettings(Settings settings) {
    if (GetIt.I<UserService>().isLoggedIn) {
      var uid = GetIt.I<UserService>().getUid();
      return GetIt.I<FirestoreService>()
          .saveDocument('settings', uid, settings.toJson());
    } else {
      return GetIt.I<StorageService>().saveSettings(settings);
    }
  }
}
