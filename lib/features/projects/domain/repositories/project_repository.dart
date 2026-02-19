import '../../../editor/domain/entities/project.dart';

abstract class ProjectRepository {
  /// Persists a project locally.
  Future<void> saveProject(Project project);

  /// Loads a single project by id. Returns null if not found.
  Future<Project?> loadProject(String id);

  /// Loads all saved projects, sorted by updatedAt descending.
  Future<List<Project>> loadAllProjects();

  /// Permanently deletes a project.
  Future<void> deleteProject(String id);
}
