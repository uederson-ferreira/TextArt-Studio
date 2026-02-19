import 'package:equatable/equatable.dart';
import '../../../editor/domain/entities/project.dart';

enum ProjectStatus { initial, loading, loaded, error }

class ProjectState extends Equatable {
  final ProjectStatus status;
  final List<Project> projects;
  final String? errorMessage;

  const ProjectState({
    this.status = ProjectStatus.initial,
    this.projects = const [],
    this.errorMessage,
  });

  ProjectState copyWith({
    ProjectStatus? status,
    List<Project>? projects,
    String? errorMessage,
  }) {
    return ProjectState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, projects, errorMessage];
}
