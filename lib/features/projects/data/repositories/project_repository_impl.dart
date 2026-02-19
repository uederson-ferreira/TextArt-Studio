import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../editor/domain/entities/project.dart';
import '../../domain/repositories/project_repository.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  static const _idsKey = 'project_ids';
  static const _prefix = 'project_';

  @override
  Future<void> saveProject(Project project) async {
    final prefs = await SharedPreferences.getInstance();

    // Update the index list
    final ids = _getIds(prefs);
    if (!ids.contains(project.id)) {
      ids.add(project.id);
      await prefs.setString(_idsKey, jsonEncode(ids));
    }

    // Persist the project JSON
    await prefs.setString(_prefix + project.id, jsonEncode(project.toJson()));
  }

  @override
  Future<Project?> loadProject(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefix + id);
    if (raw == null) return null;
    return Project.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<List<Project>> loadAllProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = _getIds(prefs);

    final projects = <Project>[];
    for (final id in ids) {
      final raw = prefs.getString(_prefix + id);
      if (raw != null) {
        try {
          projects.add(
            Project.fromJson(jsonDecode(raw) as Map<String, dynamic>),
          );
        } catch (_) {
          // Skip corrupted entries
        }
      }
    }

    projects.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return projects;
  }

  @override
  Future<void> deleteProject(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = _getIds(prefs)..remove(id);
    await prefs.setString(_idsKey, jsonEncode(ids));
    await prefs.remove(_prefix + id);
  }

  List<String> _getIds(SharedPreferences prefs) {
    final raw = prefs.getString(_idsKey);
    if (raw == null) return [];
    return List<String>.from(jsonDecode(raw) as List<dynamic>);
  }
}
