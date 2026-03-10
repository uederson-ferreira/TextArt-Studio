import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/datasources/giphy_api.dart';
import '../../domain/entities/sticker_entity.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_typography.dart';

const _quickCategories = [
  ('Em Alta', ''),
  ('Engraçado', 'funny'),
  ('Amor', 'love'),
  ('Festa', 'party'),
  ('Dança', 'dance'),
  ('Animais', 'animals'),
  ('Comida', 'food'),
  ('Esporte', 'sport'),
  ('Música', 'music'),
  ('Feliz', 'happy'),
  ('Triste', 'sad'),
  ('Surpresa', 'wow'),
  ('Parabéns', 'congratulations'),
  ('Obrigado', 'thank you'),
];

class GiphySearchPage extends StatefulWidget {
  final ValueChanged<StickerEntity> onStickerSelected;

  const GiphySearchPage({super.key, required this.onStickerSelected});

  @override
  State<GiphySearchPage> createState() => _GiphySearchPageState();
}

class _GiphySearchPageState extends State<GiphySearchPage>
    with SingleTickerProviderStateMixin {
  final _api = GiphyApi();
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late TabController _modeTab;

  List<GiphyResult> _results = [];
  bool _loading = false;
  bool _loadingMore = false;
  String _activeQuery = '';
  int _activeCategory = 0;
  int _offset = 0;
  bool _hasMore = true;
  static const _pageSize = 30;

  bool get _stickersMode => _modeTab.index == 1;

  @override
  void initState() {
    super.initState();
    _modeTab = TabController(length: 2, vsync: this);
    _modeTab.addListener(() {
      if (!_modeTab.indexIsChanging) _loadCategory(_activeCategory);
    });
    _loadCategory(0);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _modeTab.dispose();
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
    setState(() => _activeCategory = index);
    _controller.clear();
    final query = _quickCategories[index].$2;
    _activeQuery = query;
    _doLoad(reset: true);
  }

  void _doSearch(String query) {
    setState(() => _activeCategory = -1);
    _activeQuery = query.trim();
    _doLoad(reset: true);
  }

  void _doLoad({bool reset = false}) {
    if (reset) {
      setState(() {
        _loading = true;
        _results = [];
        _offset = 0;
        _hasMore = true;
      });
    }

    final Future<List<GiphyResult>> future = _activeQuery.isEmpty
        ? _api.trending(offset: 0, limit: _pageSize, stickersOnly: _stickersMode)
        : _api.search(_activeQuery, offset: 0, limit: _pageSize, stickersOnly: _stickersMode);

    future.then((results) {
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
    final nextOffset = _offset + _pageSize;
    final results = _activeQuery.isEmpty
        ? await _api.trending(
            offset: nextOffset, limit: _pageSize, stickersOnly: _stickersMode)
        : await _api.search(
            _activeQuery, offset: nextOffset, limit: _pageSize, stickersOnly: _stickersMode);
    if (!mounted) return;
    setState(() {
      _offset = nextOffset;
      _results = [..._results, ...results];
      _loadingMore = false;
      _hasMore = results.length >= _pageSize;
    });
  }

  void _selectResult(GiphyResult result) {
    final sticker = StickerEntity(
      id: 'giphy_${result.id}',
      name: result.title.isEmpty ? 'GIF' : result.title,
      assetPath: result.originalUrl,
      category: StickerCategory.objects,
      renderType: StickerRenderType.gif,
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
        title: Row(
          children: [
            Text('GIFs Animados', style: AppTypography.titleMedium()),
            const SizedBox(width: 8),
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/Giphy_Logo.svg/120px-Giphy_Logo.svg.png',
              height: 18,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(104),
          child: Column(
            children: [
              // Modo GIFs / Stickers
              TabBar(
                controller: _modeTab,
                tabs: const [
                  Tab(text: 'GIFs'),
                  Tab(text: 'Stickers'),
                ],
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondaryDark,
              ),
              // Campo de busca
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Buscar GIFs...',
                    hintStyle:
                        TextStyle(color: AppColors.textSecondaryDark),
                    prefixIcon: const Icon(Icons.search,
                        color: Colors.white54, size: 20),
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear,
                                color: Colors.white54, size: 18),
                            onPressed: () {
                              _controller.clear();
                              setState(() {});
                              _loadCategory(_activeCategory < 0 ? 0 : _activeCategory);
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
                    if (v.trim().isNotEmpty) _doSearch(v);
                  },
                  onChanged: (v) => setState(() {}),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Categorias rápidas
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              itemCount: _quickCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final active = _activeCategory == index;
                return GestureDetector(
                  onTap: () => _loadCategory(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
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
          const SizedBox(height: 4),
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
            const Icon(Icons.gif_box_outlined, size: 56, color: Colors.white30),
            const SizedBox(height: 12),
            Text('Nenhum GIF encontrado', style: AppTypography.bodyMedium()),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n is ScrollUpdateNotification) _onScroll();
        return false;
      },
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 1,
        ),
        itemCount: _results.length + (_loadingMore ? 3 : 0),
        itemBuilder: (context, index) {
          if (index >= _results.length) {
            return const Center(
              child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          final result = _results[index];
          return GestureDetector(
            onTap: () => _selectResult(result),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              child: CachedNetworkImage(
                imageUrl: result.previewUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.surfaceHighDark,
                  child: const Center(
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.surfaceHighDark,
                  child: const Icon(Icons.broken_image_outlined,
                      color: Colors.white30),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
