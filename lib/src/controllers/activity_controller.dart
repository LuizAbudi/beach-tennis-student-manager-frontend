import 'dart:convert';

import 'package:mobile/src/models/activity_model.dart';
import 'package:mobile/src/services/http_client.dart';

abstract class IActivityController {
  Future<List<ActivityModel>> getActivities();
  Future<List<ActivityModel>> getMyActivities();
  Future<void> createActivity(ActivityModel activity);
  Future<void> linkActivity(int activityId, int userId);
  Future<void> unlinkActivity(int activityId, int userId);
  Future<void> finishActivity(int activityId, int userId);
  Future<void> updateActivity(ActivityModel activity);
  Future<void> deleteActivity(int id);
  Future<ActivityModel?> getActivityById(int id);
}

class ActivityController implements IActivityController {
  final IHttpClient client;
  final baseUrl = "/atividades";
  final baseUrlUserActivity = "/usuario-atividade";

  ActivityController({required this.client});

  @override
  Future<List<ActivityModel>> getActivities() async {
    final response = await client.get(url: baseUrl);

    if (response.statusCode == 200) {
      final List<ActivityModel> activities = [];
      final body = jsonDecode(response.body);

      body['data'].map((item) {
        final ActivityModel activity = ActivityModel.fromJson(item);
        activities.add(activity);
      }).toList();

      return activities;
    } else {
      return [];
    }
  }

  @override
  Future<List<ActivityModel>> getMyActivities() async {
    final newUrl = "$baseUrl/minhas";
    final response = await client.get(url: newUrl);

    if (response.statusCode == 200) {
      final List<ActivityModel> activities = [];
      final body = jsonDecode(response.body);

      body['data'].map((item) {
        final ActivityModel activity = ActivityModel.fromJson(item);
        activities.add(activity);
      }).toList();

      return activities;
    } else {
      return [];
    }
  }

  @override
  Future<void> createActivity(ActivityModel activity) async {
    final Map<String, dynamic> data = activity.toJson();

    final response = await client.post(url: baseUrl, body: data);

    if (response.statusCode != 201) {
      final responseData = jsonDecode(response.body);
      throw responseData['error']['message'];
    }
  }

  @override
  Future<void> linkActivity(int activityId, int userId) async {
    final Map<String, dynamic> data = {
      "atividadeId": activityId,
      "usuarioId": userId,
    };

    final newUrl = "$baseUrlUserActivity/vincular-atividade";
    final response = await client.post(url: newUrl, body: data);

    if (response.statusCode != 201) {
      final responseData = jsonDecode(response.body);
      throw responseData['error']['message'];
    }
  }

  @override
  Future<void> finishActivity(int activityId, int userId) async {
    final Map<String, dynamic> data = {
      "atividadeId": activityId,
      "usuarioId": userId,
    };

    final newUrl = "$baseUrlUserActivity/entregar";
    final response = await client.put(url: newUrl, body: data);

    if (response.statusCode != 201) {
      final responseData = jsonDecode(response.body);
      throw responseData['error']['message'];
    }
  }

  @override
  Future<void> unlinkActivity(int activityId, int userId) async {
    final Map<String, dynamic> data = {
      "atividadeId": activityId,
      "usuarioId": userId,
    };

    final newUrl = "$baseUrlUserActivity/desvincular-atividade";
    final response = await client.post(url: newUrl, body: data);

    if (response.statusCode != 201) {
      final responseData = jsonDecode(response.body);
      throw responseData['error']['message'];
    }
  }

  @override
  Future<void> updateActivity(ActivityModel activity) async {
    final Map<String, dynamic> data = activity.toJson();

    final response = await client.put(url: baseUrl, body: data);

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      throw responseData['error']['message'];
    }
  }

  @override
  Future<void> deleteActivity(int id) async {
    final response = await client.delete(url: baseUrl, id: id);

    if (response.statusCode != 200) {
      final responseData = jsonDecode(response.body);
      throw responseData['error']['message'];
    }
  }

  @override
  Future<ActivityModel?> getActivityById(int id) async {
    final response = await client.get(url: baseUrl, id: id);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body.containsKey('data')) {
        final item = body['data'];

        final ActivityModel activity = ActivityModel.fromJson(item);

        return activity;
      }
    } else {
      return null;
    }

    return null;
  }
}
