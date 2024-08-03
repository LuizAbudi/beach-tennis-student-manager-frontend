import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/models/user_model.dart';

class UserStore {
  final IUserController controller;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<List<UserModel>> state =
      ValueNotifier<List<UserModel>>([]);

  final ValueNotifier<String> error = ValueNotifier<String>("");

  UserStore({required this.controller});

  Future<void> getUsers() async {
    isLoading.value = true;
    error.value = '';

    try {
      final result = await controller.getUsers();
      state.value = result;
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }

    isLoading.value = false;
  }

  Future<void> createUser(UserModel user) async {
    isLoading.value = true;
    error.value = '';

    try {
      await controller.createUser(user);
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<void> login(UserModel user) async {
    isLoading.value = true;
    error.value = '';

    try {
      final token = await controller.login(user);
      localStorage.setItem("token", token);
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<void> updateUser(UserModel user) async {
    isLoading.value = true;
    error.value = '';

    try {
      await controller.updateUser(user);
      await getUsers();
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<void> deleteUser(int id) async {
    isLoading.value = true;
    error.value = '';

    try {
      await controller.deleteUser(id);
      await getUsers();
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<UserModel?> getUserById(int id) async {
    isLoading.value = true;
    error.value = '';

    try {
      return await controller.getUserById(id);
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
    }

    isLoading.value = false;

    return null;
  }
}
