import 'package:flutter/foundation.dart';
import 'package:mobile/src/controllers/classes_controller.dart';
import 'package:mobile/src/models/classes_model.dart';

class ClassStore {
  final IClassController controller;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isSuccess = ValueNotifier<bool>(false);

  final ValueNotifier<List<ClassModel>> state =
      ValueNotifier<List<ClassModel>>([]);

  final ValueNotifier<String> error = ValueNotifier<String>("");

  final ValueNotifier<ClassModel?> selectedClass =
      ValueNotifier<ClassModel?>(null);

  ClassStore({required this.controller});

  Future<void> getClasses() async {
    isLoading.value = true;
    error.value = '';

    try {
      final result = await controller.getClasses();

      state.value = result;
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<void> createClass(ClassModel classModel) async {
    isLoading.value = true;
    error.value = '';
    isSuccess.value = false;

    try {
      await controller.createClass(classModel);
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

  Future<void> getClassById(int id) async {
    isLoading.value = true;
    error.value = '';

    try {
      final result = await controller.getClassById(id);

      selectedClass.value = result;
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
    }

    isLoading.value = false;
  }
}
