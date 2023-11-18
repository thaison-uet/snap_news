import 'package:news_app/src/utils/app_util.dart';

import '../../../core/core.dart';

abstract class NetworkLocalDataSource {
  Future<bool> updateApiKey();
  Future<void> writeApiKey(String key);
  Future<String?> readApiKey();
}

// ignore: constant_identifier_names
const API_KEY = "API_KEY";

class NetworkLocalDataSourceImpl implements NetworkLocalDataSource {
  final StorageHelper storage;

  NetworkLocalDataSourceImpl(this.storage);

  @override
  Future<bool> updateApiKey() async {
    final currentApiKey = await storage.read(API_KEY);
    var indexApiKey = listApiKey.indexOf(currentApiKey);
    var canUpdateApiKey = indexApiKey < listApiKey.length - 1;
    if (canUpdateApiKey) {
      String newApiKey = listApiKey[indexApiKey + 1];
      await storage.write(
        StorageItems(key: API_KEY, value: newApiKey),
      );
      print("SSSSS: updateApiKey: $newApiKey");
      AppUtil.instance.apiKey = newApiKey;
      AppUtil.instance.isJustUpdatedApiKey = true;

      /// Delay 2s to avoid duplicate update api key
      Future.delayed(const Duration(milliseconds: 2000), () {
        AppUtil.instance.isJustUpdatedApiKey = false;
      });
      return true;
    } else {
      AppUtil.instance.isJustUpdatedApiKey = false;
      return false;
    }
  }

  @override
  Future<void> writeApiKey(String key) async {
    print("SSSSS: writeApiKey: $key");
    await storage.write(
      StorageItems(key: API_KEY, value: key),
    );
    AppUtil.instance.apiKey = key;
    // AppUtil.instance.isJustUpdatedApiKey = true;
  }

  @override
  Future<String?> readApiKey() async {
    final apiKey = await storage.read(API_KEY);
    return apiKey;
  }
}
