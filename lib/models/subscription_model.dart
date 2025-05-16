import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SubscriptionModel {
  static const String _proSubscriptionKey = 'pro_subscription';
  static const String _subscriptionExpiryKey = 'subscription_expiry';
  
  final GetStorage _storage = GetStorage();
  
  final RxBool isPro = false.obs;
  final Rx<DateTime?> expiryDate = Rx<DateTime?>(null);
  
  static final SubscriptionModel _instance = SubscriptionModel._internal();
  
  factory SubscriptionModel() {
    return _instance;
  }
  
  SubscriptionModel._internal() {
    _loadSubscriptionStatus();
  }
  
  void _loadSubscriptionStatus() {
    final bool hasPro = _storage.read(_proSubscriptionKey) ?? false;
    final String? expiryString = _storage.read(_subscriptionExpiryKey);
    
    isPro.value = hasPro;
    
    if (expiryString != null) {
      try {
        final DateTime expiry = DateTime.parse(expiryString);
        if (expiry.isAfter(DateTime.now())) {
          expiryDate.value = expiry;
        } else {
          isPro.value = false;
          expiryDate.value = null;
          _storage.write(_proSubscriptionKey, false);
          _storage.remove(_subscriptionExpiryKey);
        }
      } catch (e) {
        isPro.value = false;
        expiryDate.value = null;
        _storage.write(_proSubscriptionKey, false);
        _storage.remove(_subscriptionExpiryKey);
      }
    }
  }
  
  void activateProSubscription(int months) {
    final DateTime now = DateTime.now();
    final DateTime expiry = DateTime(now.year, now.month + months, now.day, now.hour, now.minute, now.second);
    
    isPro.value = true;
    expiryDate.value = expiry;
    
    _storage.write(_proSubscriptionKey, true);
    _storage.write(_subscriptionExpiryKey, expiry.toIso8601String());
  }
  
  void cancelProSubscription() {
    isPro.value = false;
    expiryDate.value = null;
    
    _storage.write(_proSubscriptionKey, false);
    _storage.remove(_subscriptionExpiryKey);
  }
  
  int get remainingDays {
    if (!isPro.value || expiryDate.value == null) {
      return 0;
    }
    
    final DateTime now = DateTime.now();
    final DateTime expiry = expiryDate.value!;
    
    return expiry.difference(now).inDays;
  }
  
  bool get hasProAccess => isPro.value && (expiryDate.value?.isAfter(DateTime.now()) ?? false);
}