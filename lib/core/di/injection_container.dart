import 'package:get_it/get_it.dart';
import '../../features/fonts/data/repositories/font_repository_impl.dart';
import '../../features/fonts/domain/repositories/font_repository.dart';
import '../../features/fonts/presentation/bloc/font_bloc.dart';
import '../../features/stickers/data/repositories/sticker_repository_impl.dart';
import '../../features/stickers/domain/repositories/sticker_repository.dart';
import '../../features/stickers/presentation/bloc/sticker_bloc.dart';
import '../../features/projects/data/repositories/project_repository_impl.dart';
import '../../features/projects/domain/repositories/project_repository.dart';
import '../../features/projects/presentation/bloc/project_bloc.dart';
import '../../features/editor/presentation/bloc/editor_bloc.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // ---------------------------------------------------------------------------
  // REPOSITORIES
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton<FontRepository>(() => FontRepositoryImpl());
  sl.registerLazySingleton<StickerRepository>(() => StickerRepositoryImpl());
  sl.registerLazySingleton<ProjectRepository>(() => ProjectRepositoryImpl());

  // ---------------------------------------------------------------------------
  // BLOCS
  // ---------------------------------------------------------------------------
  sl.registerFactory<FontBloc>(
    () => FontBloc(repository: sl<FontRepository>()),
  );
  sl.registerFactory<StickerBloc>(
    () => StickerBloc(repository: sl<StickerRepository>()),
  );
  sl.registerFactory<ProjectBloc>(
    () => ProjectBloc(repository: sl<ProjectRepository>()),
  );
  sl.registerFactory<EditorBloc>(
    () => EditorBloc(projectRepository: sl<ProjectRepository>()),
  );
}
