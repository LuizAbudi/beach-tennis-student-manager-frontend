import 'dart:convert';
import 'package:mobile/src/models/classes_model.dart';
import 'package:mobile/src/services/http_client.dart';

abstract class IClassController {
  Future<List<ClassModel>> getClasses(int teacherId);
  Future<void> createClass(ClassModel classModel);
  Future<ClassModel?> getClassById(int id);
}

class ClassController implements IClassController {
  final IHttpClient client;
  final baseUrl = "/api/classes";

  ClassController({required this.client});

  @override
  Future<List<ClassModel>> getClasses(int teacherId) async {
    final response = await client.get(url: '$baseUrl/teacher/$teacherId');

    if (response.statusCode == 200) {
      final List<ClassModel> classes = [];
      final body = jsonDecode(response.body);

      body.map((item) {
        final ClassModel classe = ClassModel.fromJson(item);
        classes.add(classe);
      }).toList();

      return classes;
    } else {
      return [];
    }
  }

  @override
  Future<void> createClass(ClassModel classModel) async {
    final Map<String, dynamic> data = classModel.toJson();

    final response =
        await client.post(url: "$baseUrl/create-class", body: data);

    if (response.statusCode != 201) {
      final responseData = jsonDecode(response.body);
      throw responseData['message'];
    }
  }

  @override
  Future<ClassModel?> getClassById(int id) async {
    final response = await client.get(url: "$baseUrl/$id");

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return ClassModel.fromJson(body);
    } else {
      return null;
    }
  }
}
