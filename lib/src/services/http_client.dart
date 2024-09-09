import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';

abstract class IHttpClient {
  Future get({required String url, int? id});
  Future post({required String url, required dynamic body});
  Future put({required String url, required dynamic body});
  Future delete({required String url, required int id});
}

class HttpClient implements IHttpClient {
  final client = http.Client();
  final token = localStorage.getItem('token');
  final baseUrl = dotenv.get("API_URL");

  @override
  Future get({required String url, int? id}) async {
    String newUrl = url;

    if (id != null) {
      newUrl = '$url/$id';
    }

    return await client.get(
      Uri.parse(baseUrl + newUrl),
      headers: {
        'Authorization': "Bearer $token",
      },
    );
  }

  @override
  Future post({required String url, required dynamic body}) async {
    print("to no post");
    return await client.post(
      Uri.parse(baseUrl + url),
      body: jsonEncode(body),
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      },
    );
  }

  @override
  Future put({required String url, required dynamic body}) async {
    return await client.put(
      Uri.parse(baseUrl + url),
      body: jsonEncode(body),
      headers: {
        "Accept": "application/json",
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token",
      },
    );
  }

  @override
  Future delete({required String url, required int id}) async {
    final newUrl = '$url/$id';
    return await client.delete(
      Uri.parse(baseUrl + newUrl),
      headers: {
        'Authorization': "Bearer $token",
      },
    );
  }
}
