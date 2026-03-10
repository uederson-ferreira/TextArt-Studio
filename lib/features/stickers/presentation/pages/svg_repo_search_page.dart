import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/datasources/svg_repo_api.dart';
import '../../domain/entities/sticker_entity.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_typography.dart';

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
  String _lastQuery = '';
  int _start = 0;
  bool _hasMore = true;
  static const _pageSize = 40;

  // Cache: fullName → SVG string already downloaded
  final Map<String, String> _svgCache = {};
  // Track which are being downloaded to avoid double fetch
  final Set<String> _downloading = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Start with popular suggestions
    _search('star');
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_loadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _results = [];
      _start = 0;
      _hasMore = true;
      _lastQuery = query.trim();
    });
    final results =
        await _api.search(query.trim(), start: 0, limit: _pageSize);
    if (!mounted) return;
    setState(() {
      _results = results;
      _loading = false;
      _hasMore = results.length >= _pageSize;
    });
  }

  Future<void> _loadMore() async {
    if (!_hasMore || _loadingMore) return;
    setState(() => _loadingMore = true);
    final nextStart = _start + _pageSize;
    final results =
        await _api.search(_lastQuery, start: nextStart, limit: _pageSize);
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
        const SnackBar(content: Text('Falha ao baixar o SVG. Tente outro.')),
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
        title: Text('Buscar Ícones — Iconify', style: AppTypography.titleMedium()),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: TextField(
              controller: _controller,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ex: coração, foguete, flor...',
                hintStyle:
                    TextStyle(color: AppColors.textSecondaryDark),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          _controller.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surfaceHighDark,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: _search,
              onChanged: (v) => setState(() {}),
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_results.isEmpty && _lastQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 48, color: Colors.white30),
            const SizedBox(height: 12),
            Text('Nenhum resultado para "$_lastQuery"',
                style: AppTypography.bodyMedium()),
            const SizedBox(height: 8),
            Text('Tente em inglês: "heart", "rocket", "flower"',
                style: AppTypography.labelSmall(
                    color: AppColors.textSecondaryDark)),
          ],
        ),
      );
    }
    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_emotions_outlined,
                size: 48, color: Colors.white30),
            const SizedBox(height: 12),
            Text('Busque por qualquer figura',
                style: AppTypography.bodyMedium()),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: ['heart', 'star', 'arrow', 'flower', 'rocket', 'crown']
                  .map((s) => ActionChip(
                        label: Text(s),
                        onPressed: () {
                          _controller.text = s;
                          _search(s);
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Text('${_results.length} resultados para "$_lastQuery"',
                  style: AppTypography.labelSmall(
                      color: AppColors.textSecondaryDark)),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: _results.length + (_loadingMore ? 4 : 0),
            itemBuilder: (context, index) {
              if (index >= _results.length) {
                return const Center(
                    child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2)));
              }
              final result = _results[index];
              final isDownloading = _downloading.contains(result.fullName);
              final cached = _svgCache[result.fullName];

              return GestureDetector(
                onTap: () => _selectResult(result),
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
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2)))
                      : cached != null
                          ? SvgPicture.string(cached, fit: BoxFit.contain)
                          : SvgPicture.network(
                              result.downloadUrl,
                              fit: BoxFit.contain,
                              placeholderBuilder: (_) => const Center(
                                child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2)),
                              ),
                            ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
