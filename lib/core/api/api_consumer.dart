abstract class ApiConsumer {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});
  Future<dynamic> post(String path,
      {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters});
        Future<dynamic> post2(String path,
    {dynamic body, Map<String, dynamic>? queryParameters});

  Future<dynamic> put(String path,
      {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters});
  Future<dynamic> put2(String path,
      {dynamic body, Map<String, dynamic>? queryParameters});
  Future<dynamic> delete(String path, {Map<String, dynamic>? queryParameters});
}
