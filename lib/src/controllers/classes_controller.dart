import 'dart:convert';

import 'package:mobile/src/models/classes_model.dart';
import 'package:mobile/src/services/http_client.dart';

abstract class IClassController {
  Future<List<ClassModel>> getClasses();
  Future<void> createClass(ClassModel classModel);
}

class ClassController implements IClassController {
  final IHttpClient client;
  final baseUrl = "/api/classes";

  ClassController({required this.client});

  @override
  Future<List<ClassModel>> getClasses() async {
    final response = await client.get(url: "/api/classes");

    if (response.statusCode == 200) {
      final List<ClassModel> classes = [];
      final body = jsonDecode(response.body);

      print(body);
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

    final response = await client.post(url: "/api/classes/create-class", body: data);

    if (response.statusCode != 201) {
      final responseData = jsonDecode(response.body);
      throw responseData['message'];
    }
  }
}
