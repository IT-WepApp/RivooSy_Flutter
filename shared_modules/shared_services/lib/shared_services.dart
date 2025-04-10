library shared_services;

class ApiService {
  Future<String> fetchData() async {
    // مثال لاستدعاء API مشترك
    return Future.delayed(const Duration(seconds: 1), () => 'بيانات من API مشترك');
  }
}
