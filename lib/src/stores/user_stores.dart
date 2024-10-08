import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mobile/src/controllers/user_controller.dart';
import 'package:mobile/src/models/student_model.dart';
import 'package:mobile/src/models/user_model.dart';

class UserStore {
  final IUserController controller;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isSuccess = ValueNotifier<bool>(false);

  final ValueNotifier<List<StudentModel>> state =
      ValueNotifier<List<StudentModel>>([]);

  final ValueNotifier<String> error = ValueNotifier<String>("");

  UserStore({required this.controller});

  Future<void> getStudents(int teacherId) async {
    isLoading.value = true;
    error.value = '';

    try {
      final result = await controller.getStudents(teacherId);
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

  Future<void> createStudent(UserModel user) async {
    isLoading.value = true;
    error.value = '';
    isSuccess.value = false;

    try {
      await controller.createStudent(user);
      isSuccess.value = true;
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
      isSuccess.value = false;
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
      // await getStudents();
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
      // await getStudents();
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<StudentModel?> getUserById(int id) async {
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

  Future<UserModel?> getMe() async {
    isLoading.value = true;
    error.value = '';

    try {
      final user = await controller.getMe();
      return user;
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
