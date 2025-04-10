class DeliveryService {
  Future<String> fetchDeliveryStatus() async {
    // مثال: الاتصال بواجهة API للحصول على حالة الطلب
    return Future.delayed(const Duration(seconds: 1), () => 'حالة الطلب: جاري التوصيل');
  }
}
