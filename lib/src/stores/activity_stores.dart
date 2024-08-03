import 'package:flutter/foundation.dart';
import 'package:mobile/src/controllers/activity_controller.dart';
import 'package:mobile/src/models/activity_model.dart';

class ActivityStore {
  final IActivityController controller;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<List<ActivityModel>> state =
      ValueNotifier<List<ActivityModel>>([]);

  final ValueNotifier<String> error = ValueNotifier<String>("");

  ActivityStore({required this.controller});

  Future<void> getActivities() async {
    isLoading.value = true;
    error.value = "";

    try {
      final result = await controller.getActivities();
      state.value = result;
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }

    isLoading.value = false;
  }

  Future<void> getMyActivities() async {
    isLoading.value = true;
    error.value = "";

    try {
      final result = await controller.getMyActivities();
      state.value = result;
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }

    isLoading.value = false;
  }

  Future<void> createActivity(ActivityModel activity) async {
    isLoading.value = true;
    error.value = "";

    try {
      await controller.createActivity(activity);
      await getActivities();
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<void> linkActivity(int activityId, int userId) async {
    isLoading.value = true;
    error.value = "";

    try {
      await controller.linkActivity(activityId, userId);
      await getMyActivities();
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<void> unlinkActivity(int activityId, int userId) async {
    isLoading.value = true;
    error.value = "";

    try {
      await controller.unlinkActivity(activityId, userId);
      await getMyActivities();
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<void> finishActivity(int activityId, int userId) async {
    isLoading.value = true;
    error.value = "";

    try {
      await controller.finishActivity(activityId, userId);
      await getMyActivities();
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<void> updateActivity(ActivityModel activity) async {
    isLoading.value = true;
    error.value = "";

    try {
      await controller.updateActivity(activity);
      await getActivities();
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<void> deleteActivity(int id) async {
    isLoading.value = true;
    error.value = "";

    try {
      await controller.deleteActivity(id);
      await getActivities();
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      error.value = e.toString();
    }

    isLoading.value = false;
  }

  Future<ActivityModel?> getActivityById(int id) async {
    isLoading.value = true;
    error.value = "";

    try {
      return await controller.getActivityById(id);
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
