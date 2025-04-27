// lib/api_service.dart
import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000/api/'));

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    try {
      final response = await dio.get('tasks');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> createTask(String title) async {
    try {
      await dio.post('tasks', data: {'title': title, 'status': 'pending'});
    } catch (e) {
      throw Exception('Failed to create task');
    }
  }

  Future<void> updateTask(int taskId, String status) async {
    try {
      await dio.put('tasks/$taskId', data: {'status': status});
    } catch (e) {
      throw Exception('Failed to update task');
    }
  }
}
