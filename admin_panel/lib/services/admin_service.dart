class AdminService {
  // دالة تجريبية لجلب تقرير
  Future<String> fetchReport() async {
    // هنا يمكنك استدعاء API لتنفيذ العملية
    return Future.delayed(const Duration(seconds: 1), () => 'بيانات التقرير');
  }
}
