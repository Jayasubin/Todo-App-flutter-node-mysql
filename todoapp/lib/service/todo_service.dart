import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/todo.dart';

class TodoService {
  static final TodoService _todoSingleton = TodoService._internal();

  factory TodoService() {
    return _todoSingleton;
  }

  TodoService._internal();

  String baseUrl = 'http://192.168.1.6:2500/todo_express/api/todos';

  String currentInfo = '';

  void showCustomSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(currentInfo),
      duration: const Duration(milliseconds: 600),
    ));
  }

  Future<List<Todo>> getPending() async {
    List<Todo> pending = [];

    http.Response response = await http.get(Uri.parse('$baseUrl/pending'));

    var decoded = jsonDecode(response.body);
    currentInfo = decoded['info'];

    if (response.statusCode == 200) {
      List rows = decoded['rows'];

      for (var row in rows) {
        pending.add(Todo(
          id: row['id'],
          title: row['title'],
          description: row['description'],
          time: row['time'] != null ? DateTime.parse(row['time']) : null,
        ));
      }
    }

    return pending;
  }

  Future<List<Todo>> getCompleted() async {
    List<Todo> completed = [];

    http.Response response = await http.get(Uri.parse('$baseUrl/completed'));

    var decoded = jsonDecode(response.body);
    currentInfo = decoded['info'];

    if (response.statusCode == 200) {
      List rows = decoded['rows'];

      for (var row in rows) {
        completed.add(Todo(
          id: row['id'],
          title: row['title'],
          description: row['description'],
          time: row['time'] != null ? DateTime.parse(row['time']) : null,
        ));
      }
    }

    return completed;
  }

  //void getAll() {}

  //void getDetail({required int id}) {}

  Future<bool> add({
    required String title,
    required String description,
  }) async {
    var response = await http.post(Uri.parse('$baseUrl/'), body: {
      "title": title,
      "description": description,
    });
    var decoded = jsonDecode(response.body);

    currentInfo = decoded['info'];
    return response.statusCode == 200;
  }

  Future<bool> edit({
    required int id,
    required String newTitle,
    required String newDesc,
  }) async {
    var response = await http.put(Uri.parse('$baseUrl/edit/$id'), body: {
      "title": newTitle,
      "description": newDesc,
    });

    var decoded = jsonDecode(response.body);
    currentInfo = decoded['info'];

    return response.statusCode == 200;
  }

  Future<bool> update({
    required int id,
    required DateTime? completedTime,
  }) async {
    http.Response response;

    if (completedTime != null) {
      response = await http.put(Uri.parse('$baseUrl/update/$id'), body: {
        "time": completedTime.toIso8601String(),
      });
    } else {
      response = await http.put(Uri.parse('$baseUrl/update/$id'),
          body: jsonEncode({
            "time": null,
          }));
    }
    var decoded = jsonDecode(response.body);
    currentInfo = decoded['info'];

    return response.statusCode == 200;
  }

  Future<bool> delete({required int id}) async {
    var response = await http.delete(Uri.parse('$baseUrl/$id'));

    var decoded = jsonDecode(response.body);
    currentInfo = decoded['info'];

    return response.statusCode == 200;
  }
}
