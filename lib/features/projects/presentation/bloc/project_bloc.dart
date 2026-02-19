import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/project_repository.dart';
import 'project_event.dart';
import 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final ProjectRepository _repository;

  ProjectBloc({required ProjectRepository repository})
      : _repository = repository,
        super(const ProjectState()) {
    on<ProjectLoadAll>(_onLoadAll);
    on<ProjectSave>(_onSave);
    on<ProjectDelete>(_onDelete);
  }

  Future<void> _onLoadAll(
      ProjectLoadAll event, Emitter<ProjectState> emit) async {
    emit(state.copyWith(status: ProjectStatus.loading));
    try {
      final projects = await _repository.loadAllProjects();
      emit(state.copyWith(status: ProjectStatus.loaded, projects: projects));
    } catch (e) {
      emit(state.copyWith(
          status: ProjectStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onSave(ProjectSave event, Emitter<ProjectState> emit) async {
    try {
      await _repository.saveProject(event.project);
      final updated = await _repository.loadAllProjects();
      emit(state.copyWith(status: ProjectStatus.loaded, projects: updated));
    } catch (e) {
      emit(state.copyWith(
          status: ProjectStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> _onDelete(
      ProjectDelete event, Emitter<ProjectState> emit) async {
    try {
      await _repository.deleteProject(event.projectId);
      final updated = state.projects
          .where((p) => p.id != event.projectId)
          .toList();
      emit(state.copyWith(projects: updated));
    } catch (e) {
      emit(state.copyWith(
          status: ProjectStatus.error, errorMessage: e.toString()));
    }
  }
}
