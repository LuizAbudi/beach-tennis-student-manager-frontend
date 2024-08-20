import 'dart:convert';

import 'package:mobile/src/models/user_model.dart';
import 'package:mobile/src/services/http_client.dart';

abstract class IUserController {
  Future<List<UserModel>> getUsers();
  Future<void> createUser(UserModel user);
  Future<String> login(UserModel user);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(int id);
  Future<UserModel?> getUserById(int id);
}

class UserController implements IUserController {
  final IHttpClient client;
  final baseUrl = "/api/users";

  UserController({required this.client});

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await client.get(url: "/api/students/all");

    if (response.statusCode == 200) {
      final List<UserModel> users = [];
      final body = jsonDecode(response.body);

      body.map((item) {
        final UserModel user = UserModel.fromJson(item);
        users.add(user);
      }).toList();

      return users;
    } else {
      return [];
    }
  }

  @override
  Future<void> createUser(UserModel user) async {
    final Map<String, dynamic> data = user.toJson();
    print(data);
    const registerUrl = "/api/register";
    final response = await client.post(url: registerUrl, body: data);

    if (response.statusCode != 201) {
      final responseData = jsonDecode(response.body);
      throw responseData['message'];
    }
  }

  @override
  Future<String> login(UserModel user) async {
    final Map<String, dynamic> data = user.toJson();
    const loginUrl = '/api/login';

    final response = await client.post(url: loginUrl, body: data);

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);

      final token = responseData['access_token'];

      return token;
    } else {
      final responseData = jsonDecode(response.body);
      throw responseData['error']['message'];
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final Map<String, dynamic> data = user.toJson();

    final response = await client.put(url: baseUrl, body: data);

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      throw responseData['error']['message'];
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    final response = await client.delete(url: baseUrl, id: id);

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      throw responseData['error']['message'];
    }
  }

  @override
  Future<UserModel?> getUserById(int id) async {
    final response = await client.get(url: baseUrl, id: id);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body.containsKey('data')) {
        final item = body['data'];

        final UserModel user = UserModel.fromJson(item);

        return user;
      }
    } else {
      return null;
    }

    return null;
  }
}
