import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'subscription_model.dart';

class ImageUploadModel {
  static const String _uploadCountKey = 'daily_file_uploads';
  static const String _lastUploadDateKey = 'last_upload_date';
  static const int _freeUserDailyLimit = 3;

  final GetStorage _storage = GetStorage();
  final SubscriptionModel _subscriptionModel = SubscriptionModel();

  final RxInt dailyUploads = 0.obs;
  final Rx<DateTime?> lastUploadDate = Rx<DateTime?>(null);

  static final ImageUploadModel _instance = ImageUploadModel._internal();

  factory ImageUploadModel() {
    return _instance;
  }

  ImageUploadModel._internal() {
    _loadUploadStats();
  }

  void _loadUploadStats() {
    final int uploads = _storage.read(_uploadCountKey) ?? 0;
    final String? dateString = _storage.read(_lastUploadDateKey);

    if (dateString != null) {
      try {
        final DateTime date = DateTime.parse(dateString);
        lastUploadDate.value = date;

        final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final String storedDate = DateFormat('yyyy-MM-dd').format(date);

        if (today != storedDate) {
          dailyUploads.value = 0;
          _storage.write(_uploadCountKey, 0);
          lastUploadDate.value = null;
          _storage.remove(_lastUploadDateKey);
        } else {
          dailyUploads.value = uploads;
        }
      } catch (e) {
        dailyUploads.value = 0;
        lastUploadDate.value = null;
        _storage.write(_uploadCountKey, 0);
        _storage.remove(_lastUploadDateKey);
      }
    } else {
      dailyUploads.value = 0;
    }
  }

  bool canUploadImage() {
    if (_subscriptionModel.hasProAccess) {
      return true;
    }

    return dailyUploads.value < _freeUserDailyLimit;
  }

  
  int get remainingUploads {
    if (_subscriptionModel.hasProAccess) {
      return -1; 
    }

    return _freeUserDailyLimit - dailyUploads.value;
  }

  void incrementUploadCount() {
    if (!_subscriptionModel.hasProAccess) {
      dailyUploads.value++;
      lastUploadDate.value = DateTime.now();

      _storage.write(_uploadCountKey, dailyUploads.value);
      _storage.write(
          _lastUploadDateKey, lastUploadDate.value!.toIso8601String());
    }
  }

  void resetUploadCount() {
    dailyUploads.value = 0;
    lastUploadDate.value = null;

    _storage.write(_uploadCountKey, 0);
    _storage.remove(_lastUploadDateKey);
  }
}
