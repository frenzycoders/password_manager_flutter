import 'dart:convert';

import 'package:password_manager/src/Config.dart';

import './http_service.dart';
import 'package:http/http.dart' as http;

import 'http_file.dart';
import 'multipart_body.dart';
import 'multipart_headers.dart';

class HttpImpl implements HttpService {
  var _baseUrl;

  @override
  void init() {
    print('INIT');
    _baseUrl = AppConfig.baseUrl;
  }

  @override
  Future<http.Response> getRequest(String url, headers, body) async {
    http.Response response;
    try {
      response = await http.get(Uri.parse(_baseUrl + url), headers: headers);
    } catch (e) {
      throw Exception(e);
    }
    return response;
  }

  @override
  Future<http.Response> postRequest(String url, headers, body) async {
    http.Response response;
    try {
      response = await http.post(Uri.parse(_baseUrl + url),
          body: body, headers: headers);
      print(json.decode(response.body));
    } catch (e) {
      throw Exception(e);
    }
    return response;
  }

  @override
  Future<http.Response> patchRequest(String url, var headers, var body) async {
    http.Response response;
    try {
      response = await http.patch(Uri.parse(_baseUrl + url),
          body: body, headers: headers);
    } catch (e) {
      throw Exception(e);
    }
    return response;
  }

  @override
  Future<http.Response> maltiPartedRequest(String url, List<HttpFile> files,
      List<MultiPartHeader> headers, List<MultipartBody> body) async {
    http.Response response;
    try {
      print('Hey you');
      final request =
          new http.MultipartRequest('PATCH', Uri.parse(_baseUrl + url));
      files.forEach((e) async {
        http.MultipartFile multipartFile =
            await http.MultipartFile.fromPath(e.key, e.image.path);
        request.files.add(multipartFile);
        print(multipartFile.field);
      });
      headers.forEach((e) {
        request.headers[e.key] = e.value;
        print(e.value);
      });
      body.forEach((e) {
        request.fields[e.key] = e.data;
        print(e.data);
      });
      final res = await request.send();
      print(res.statusCode);
      response = await http.Response.fromStream(res);
    } catch (e) {
      print(e);
      throw Exception(e);
    }
    return response;
  }

  @override
  Future<http.Response> deleteRequest(
      {required String url,
      required Map<String, String> headers,
      required Map<String, dynamic> body}) async {
    http.Response response;
    try {
      response = await http.delete(Uri.parse(_baseUrl + url),
          headers: headers, body: body);
    } catch (e) {
      throw Exception(e);
    }
    return response;
  }
}
