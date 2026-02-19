import 'package:equatable/equatable.dart';
import '../../../editor/domain/entities/project.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();
  @override
  List<Object?> get props => [];
}

class ProjectLoadAll extends ProjectEvent {
  const ProjectLoadAll();
}

class ProjectSave extends ProjectEvent {
  final Project project;
  const ProjectSave(this.project);
  @override
  List<Object?> get props => [project];
}

class ProjectDelete extends ProjectEvent {
  final String projectId;
  const ProjectDelete(this.projectId);
  @override
  List<Object?> get props => [projectId];
}
