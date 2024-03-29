import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import 'cache.service.dart';
import 'firestore.service.dart';
import 'user.service.dart';
import '../models/settings.dart';

final getIt = GetIt.instance;
final logger = Logger(printer: PrettyPrinter(methodCount: 0, printTime: true));

class SettingsService {
  SettingsService();

  Future<Settings> loadSettings({bool force = false}) async {
    var settings = getIt<Cache>().settings;
    if (!force && settings != null) {
      return settings;
    }
    if (getIt<UserService>().isLoggedIn) {
      var userService = getIt<UserService>();
      var uid = userService.getUid()!;
      var document = getIt<FirestoreService>().getDocument('settings', uid);
      var json = (await document).data() as Map<String, dynamic>?;
      settings = Settings.fromJson(json ?? {});
    } else {
      settings = Settings.fromJson({});
    }
    getIt<Cache>().settings = settings;
    logger.i('Reading settings: ${settings.toJson()}');
    return settings;
  }

  Future<void> saveSettings(Settings settings) async {
    logger.i('Saving: ${settings.toJson()}');
    getIt<Cache>().settings = settings;
    if (getIt<UserService>().isLoggedIn) {
      var uid = getIt<UserService>().getUid()!;
      return getIt<FirestoreService>()
          .saveDocument('settings', uid, settings.toJson());
    }
    return;
  }
}
