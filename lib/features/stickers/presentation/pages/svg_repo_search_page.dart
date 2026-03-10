import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/datasources/svg_repo_api.dart';
import '../../domain/entities/sticker_entity.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_typography.dart';

// Categorias de navegação rápida — carregam sem digitar nada
const _quickCategories = [
  ('Populares', 'icon'),
  ('Amor', 'heart'),
  ('Estrelas', 'star'),
  ('Natureza', 'flower'),
  ('Animais', 'animal'),
  ('Comida', 'food'),
  ('Espaço', 'space'),
  ('Música', 'music'),
  ('Esporte', 'sport'),
  ('Viagem', 'travel'),
  ('Arte', 'art'),
  ('Tecnologia', 'tech'),
  ('Moda', 'fashion'),
  ('Casa', 'home'),
  ('Festa', 'party'),
  ('Dinheiro', 'money'),
];

class SvgRepoSearchPage extends StatefulWidget {
  final ValueChanged<StickerEntity> onStickerSelected;

  const SvgRepoSearchPage({super.key, required this.onStickerSelected});

  @override
  State<SvgRepoSearchPage> createState() => _SvgRepoSearchPageState();
}

class _SvgRepoSearchPageState extends State<SvgRepoSearchPage> {
  final _api = SvgRepoApi();
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  List<SvgRepoResult> _results = [];
  bool _loading = false;
  bool _loadingMore = false;
  String _activeQuery = 'icon';
  int _activeCategory = 0;
  int _start = 0;
  bool _hasMore = true;
  static const _pageSize = 40;

  // Cache: fullName → SVG string already downloaded
  final Map<String, String> _svgCache = {};
  final Set<String> _downloading = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Carrega automaticamente ao abrir
    _loadCategory(0);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300 &&
        !_loadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  void _loadCategory(int index) {
    final query = _quickCategories[index].$2;
    setState(() => _activeCategory = index);
    _controller.clear();
    _doSearch(query);
  }

  void _doSearch(String query) {
    if (query.trim().isEmpty) return;
    _activeQuery = query.trim();
    setState(() {
      _loading = true;
      _results = [];
      _start = 0;
      _hasMore = true;
    });
    _api.search(_activeQuery, start: 0, limit: _pageSize).then((results) {
      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
        _hasMore = results.length >= _pageSize;
      });
    });
  }

  Future<void> _loadMore() async {
    if (!_hasMore || _loadingMore) return;
    setState(() => _loadingMore = true);
    final nextStart = _start + _pageSize;
    final results =
        await _api.search(_activeQuery, start: nextStart, limit: _pageSize);
    if (!mounted) return;
    setState(() {
      _start = nextStart;
      _results = [..._results, ...results];
      _loadingMore = false;
      _hasMore = results.length >= _pageSize;
    });
  }

  Future<void> _selectResult(SvgRepoResult result) async {
    if (_svgCache.containsKey(result.fullName)) {
      _addToCanvas(result, _svgCache[result.fullName]!);
      return;
    }
    if (_downloading.contains(result.fullName)) return;

    setState(() => _downloading.add(result.fullName));
    final svgContent = await _api.downloadSvg(result);
    if (!mounted) return;
    setState(() => _downloading.remove(result.fullName));

    if (svgContent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao carregar. Tente outro.')),
      );
      return;
    }
    _svgCache[result.fullName] = svgContent;
    _addToCanvas(result, svgContent);
  }

  void _addToCanvas(SvgRepoResult result, String svgContent) {
    final sticker = StickerEntity(
      id: 'iconify_${result.fullName.replaceAll(':', '_')}',
      name: result.title,
      assetPath: svgContent,
      category: StickerCategory.shapes,
      renderType: StickerRenderType.svg,
    );
    widget.onStickerSelected(sticker);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        title: Text('Ícones & Figuras', style: AppTypography.titleMedium()),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar (ex: coração, foguete, flor...)',
                hintStyle: TextStyle(color: AppColors.textSecondaryDark),
                prefixIcon:
                    const Icon(Icons.search, color: Colors.white54, size: 20),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: Colors.white54, size: 18),
                        onPressed: () {
                          _controller.clear();
                          setState(() {});
                          _loadCategory(_activeCategory);
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surfaceHighDark,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (v) {
                if (v.trim().isNotEmpty) {
                  setState(() => _activeCategory = -1);
                  _doSearch(v);
                }
              },
              onChanged: (v) => setState(() {}),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Categorias rápidas
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: _quickCategories.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppSizes.space8),
              itemBuilder: (context, index) {
                final active = _activeCategory == index;
                return GestureDetector(
                  onTap: () => _loadCategory(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 0),
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.primary
                          : AppColors.surfaceHighDark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _quickCategories[index].$1,
                      style: TextStyle(
                        color: active
                            ? Colors.white
                            : AppColors.textSecondaryDark,
                        fontSize: 13,
                        fontWeight: active
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Grade de resultados
          Expanded(child: _buildGrid()),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 48, color: Colors.white30),
            const SizedBox(height: 12),
            Text('Nenhum resultado', style: AppTypography.bodyMedium()),
            const SizedBox(height: 8),
            Text('Tente em inglês: "heart", "rocket"',
                style: AppTypography.labelSmall(
                    color: AppColors.textSecondaryDark)),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: _results.length + (_loadingMore ? 5 : 0),
      itemBuilder: (context, index) {
        if (index >= _results.length) {
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        final result = _results[index];
        final isDownloading = _downloading.contains(result.fullName);
        final cached = _svgCache[result.fullName];

        return GestureDetector(
          onTap: () => _selectResult(result),
          child: Tooltip(
            message: result.title,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceHighDark,
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(color: AppColors.dividerDark),
              ),
              padding: const EdgeInsets.all(6),
              child: isDownloading
                  ? const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : cached != null
                      ? SvgPicture.string(cached, fit: BoxFit.contain)
                      : SvgPicture.network(
                          result.downloadUrl,
                          fit: BoxFit.contain,
                          placeholderBuilder: (_) => const Center(
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
            ),
          ),
        );
      },
    );
  }
}
