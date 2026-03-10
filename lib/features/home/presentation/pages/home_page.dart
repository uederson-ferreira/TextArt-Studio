import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../editor/domain/entities/project.dart';
import '../../../projects/presentation/bloc/project_bloc.dart';
import '../../../projects/presentation/bloc/project_event.dart';
import '../../../projects/presentation/bloc/project_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProjectBloc>()..add(const ProjectLoadAll()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  GoRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final router = GoRouter.of(context);
    if (_router != router) {
      _router?.routerDelegate.removeListener(_onRouteChanged);
      _router = router;
      _router!.routerDelegate.addListener(_onRouteChanged);
    }
  }

  void _onRouteChanged() {
    // When we return to home, reload project list
    final location = _router?.state.uri.toString();
    if (location == AppRoutes.home && mounted) {
      context.read<ProjectBloc>().add(const ProjectLoadAll());
    }
  }

  @override
  void dispose() {
    _router?.routerDelegate.removeListener(_onRouteChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFab(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                AppColors.gradientBrand.createShader(bounds),
            child: Text(
              'TextArt',
              style: AppTypography.headlineMedium(color: Colors.white),
            ),
          ),
          Text(
            ' Studio',
            style:
                AppTypography.headlineMedium(color: AppColors.textPrimaryDark),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<ProjectBloc, ProjectState>(
      builder: (context, state) {
        final projects = state.projects;
        final hasProjects = projects.isNotEmpty;

        return CustomScrollView(
          slivers: [
            // Hero section
            SliverToBoxAdapter(
              child: _buildHeroSection(context),
            ),

            // Recent projects header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSizes.screenPadding,
                  AppSizes.space24,
                  AppSizes.screenPadding,
                  AppSizes.space12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Projetos Recentes',
                        style: AppTypography.titleLarge()),
                    if (hasProjects)
                      TextButton(
                        onPressed: () {},
                        child: const Text('Ver todos'),
                      ),
                  ],
                ),
              ),
            ),

            if (state.status == ProjectStatus.loading)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.space32),
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            else if (hasProjects)
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSizes.space12,
                    mainAxisSpacing: AppSizes.space12,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final project = projects[index];
                      return _ProjectCard(
                        project: project,
                        onTap: () => context.push(
                          '/editor/${project.id}',
                        ),
                        onDelete: () {
                          context
                              .read<ProjectBloc>()
                              .add(ProjectDelete(project.id));
                        },
                      );
                    },
                    childCount: projects.length,
                  ),
                ),
              )
            else
              // Empty state
              SliverToBoxAdapter(
                child: _buildEmptyState(context),
              ),

            const SliverToBoxAdapter(
              child: SizedBox(height: AppSizes.space80),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.screenPadding),
      padding: const EdgeInsets.all(AppSizes.space24),
      decoration: BoxDecoration(
        gradient: AppColors.gradientBrandDiagonal,
        borderRadius: BorderRadius.circular(AppSizes.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Crie designs\nincríveis',
            style: AppTypography.displayMedium(color: Colors.white),
          ),
          const SizedBox(height: AppSizes.space8),
          Text(
            'Adicione texto, stickers e efeitos às suas fotos.',
            style: AppTypography.bodyMedium(
                color: Colors.white.withValues(alpha: 0.85)),
          ),
          const SizedBox(height: AppSizes.space20),
          ElevatedButton.icon(
            onPressed: () => context.push(AppRoutes.editor),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              minimumSize: const Size(0, 44),
            ),
            icon: const Icon(Icons.add),
            label: Text(
              'Novo Projeto',
              style: AppTypography.labelLarge(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.space32),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surfaceHighDark,
              borderRadius: BorderRadius.circular(AppSizes.radiusXl),
            ),
            child: const Icon(
              Icons.image_outlined,
              size: 40,
              color: AppColors.textDisabledDark,
            ),
          ),
          const SizedBox(height: AppSizes.space16),
          Text(
            'Nenhum projeto ainda',
            style:
                AppTypography.titleMedium(color: AppColors.textSecondaryDark),
          ),
          const SizedBox(height: AppSizes.space8),
          Text(
            'Crie seu primeiro projeto\nclicando no botão abaixo',
            style: AppTypography.bodyMedium(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.space24),
          GradientButton(
            label: 'Criar Projeto',
            icon: Icons.add,
            onPressed: () => context.push(AppRoutes.editor),
          ),
        ],
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => context.push(AppRoutes.editor),
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text(
        'Novo Projeto',
        style: AppTypography.labelLarge(color: Colors.white),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PROJECT CARD
// ---------------------------------------------------------------------------

class _ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProjectCard({
    required this.project,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showDeleteDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          border: Border.all(color: AppColors.dividerDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(project.backgroundColor),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSizes.radiusMd),
                  ),
                ),
                child: Center(
                  child: project.textElements.isEmpty &&
                          project.stickerElements.isEmpty
                      ? const Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: AppColors.textDisabledDark,
                        )
                      : _buildPreviewBadges(),
                ),
              ),
            ),
            // Name + date
            Padding(
              padding: const EdgeInsets.all(AppSizes.space12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: AppTypography.titleSmall(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(project.updatedAt),
                    style: AppTypography.bodySmall(
                        color: AppColors.textSecondaryDark),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewBadges() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (project.textElements.isNotEmpty)
          Text(
            project.textElements.first.text,
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        if (project.stickerElements.isNotEmpty)
          Text(
            project.stickerElements.first.assetPath,
            style: const TextStyle(fontSize: 24),
          ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inHours < 1) return '${diff.inMinutes}min atrás';
    if (diff.inDays < 1) return '${diff.inHours}h atrás';
    if (diff.inDays == 1) return 'ontem';
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir projeto'),
        content: Text('Deseja excluir "${project.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
