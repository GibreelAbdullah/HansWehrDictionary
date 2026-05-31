import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/transliteration.dart';
import '../../domain/dictionary_entry.dart';
import '../providers/dictionary_providers.dart';
import '../providers/search_history_provider.dart';

class DictionarySearchBar extends ConsumerStatefulWidget {
  const DictionarySearchBar({super.key});

  @override
  ConsumerState<DictionarySearchBar> createState() => _DictionarySearchBarState();
}

class _DictionarySearchBarState extends ConsumerState<DictionarySearchBar>
    with WidgetsBindingObserver {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  Timer? _debounce;
  bool _showDropdown = false;
  TextDirection _textDirection = TextDirection.ltr;
  bool _keyboardVisible = false;
  String _lastSetQuery = '';
  OverlayEntry? _overlayEntry;

  // Typewriter hint
  static const _hints = ['كتب', 'ktb', 'علم', 'elm'];
  int _hintIndex = 0;
  String _hintDisplay = '';
  Timer? _hintTimer;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    WidgetsBinding.instance.addObserver(this);
    _typeNext();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.platformDispatcher.views.first.viewInsets.bottom;
    final wasVisible = _keyboardVisible;
    _keyboardVisible = bottomInset > 0;
    if (wasVisible && !_keyboardVisible && _showDropdown) {
      _focusNode.unfocus();
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      _showOverlay();
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_focusNode.hasFocus) {
          _hideOverlay();
        }
      });
    }
  }

  void _showOverlay() {
    if (_showDropdown) return;
    _showDropdown = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _showDropdown = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _updateOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry() {
    final isBottom = ref.read(searchBarBottomProvider).value ?? false;

    return OverlayEntry(
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final mode = ref.watch(searchModeProvider);
          final history = ref.watch(searchHistoryProvider).value ?? [];
          final suggestions = ref.watch(searchSuggestionsProvider).value ?? [];
          final query = _controller.text.trim();

          final bool showSuggestions = query.isNotEmpty && mode == SearchMode.keyword;
          final List<DictionaryEntry> suggestionItems = showSuggestions ? suggestions.take(8).toList() : [];
          final List<String> historyItems = query.isEmpty
              ? history.take(5).toList()
              : history.where((h) => h.contains(query)).take(5).toList();

          final bool hasContent = suggestionItems.isNotEmpty || historyItems.isNotEmpty;
          if (!hasContent) return const SizedBox.shrink();

          final cs = Theme.of(context).colorScheme;

          // Calculate scrim bounds to avoid covering the search bar
          final renderBox = this.context.findRenderObject() as RenderBox?;
          final searchBarOffset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
          final searchBarHeight = renderBox?.size.height ?? 0;
          final searchBarWidth = renderBox?.size.width ?? 0;
          final screenSize = MediaQuery.of(context).size;

          final double scrimTop = isBottom ? 0 : searchBarOffset.dy + searchBarHeight;
          final double scrimBottom = isBottom ? screenSize.height - searchBarOffset.dy : 0;

          return Stack(
            children: [
              // Scrim that only covers the area outside the search bar
              Positioned(
                top: scrimTop,
                left: 0,
                right: 0,
                bottom: scrimBottom,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _focusNode.unfocus();
                    _hideOverlay();
                  },
                  child: ColoredBox(
                    color: Colors.black.withValues(alpha: 0.25),
                  ),
                ),
              ),
              // Floating dropdown — spans full search bar width
              Positioned(
                width: searchBarWidth,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: isBottom ? Offset(-36, -4) : Offset(-36, 4),
                  followerAnchor: isBottom ? Alignment.bottomLeft : Alignment.topLeft,
                  targetAnchor: isBottom ? Alignment.topLeft : Alignment.bottomLeft,
                  child: Material(
                    elevation: 12,
                    borderRadius: BorderRadius.circular(12),
                    color: cs.surfaceContainer,
                    surfaceTintColor: cs.primary,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        children: [
                          if (showSuggestions)
                            ...suggestionItems.map((entry) => ListTile(
                                  dense: true,
                                  visualDensity: VisualDensity.compact,
                                  contentPadding: EdgeInsets.only(
                                    left: entry.isRoot ? 16 : 40,
                                    right: 16,
                                  ),
                                  title: Text(
                                    entry.word,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: entry.isRoot ? 18 : 16,
                                      fontWeight: entry.isRoot ? FontWeight.bold : FontWeight.normal,
                                      color: entry.isRoot ? cs.onSurface : cs.onSurfaceVariant,
                                    ),
                                  ),
                                  onTap: () {
                                    ref.read(searchHistoryProvider.notifier).add(entry.word);
                                    _hideOverlay();
                                    _focusNode.unfocus();
                                    _navigateToEntry(context, ref, entry);
                                  },
                                ))
                          else
                            ...historyItems.map((item) => ListTile(
                                  dense: true,
                                  visualDensity: VisualDensity.compact,
                                  trailing: Icon(Icons.history,
                                      size: 18, color: cs.onSurfaceVariant),
                                  title: Text(item, textDirection: _detectDirection(item)),
                                  leading: IconButton(
                                    icon: Icon(Icons.close,
                                        size: 16, color: cs.onSurfaceVariant),
                                    onPressed: () {
                                      ref.read(searchHistoryProvider.notifier).remove(item);
                                    },
                                  ),
                                  onTap: () => _selectHistory(item),
                                )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _navigateToEntry(BuildContext _, WidgetRef ref, DictionaryEntry entry) async {
    final repo = ref.read(repositoryProvider);
    if (entry.isRoot) {
      if (mounted) context.push('/entry/${entry.word}');
    } else {
      final parent = await repo.getEntry(entry.parentId);
      if (parent != null && mounted) {
        context.push('/entry/${parent.word}?highlight=${entry.id}');
      }
    }
  }

  void _typeNext() {
    final word = _hints[_hintIndex];
    int charIndex = 0;
    _hintDisplay = '';
    _hintTimer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      if (!mounted) { timer.cancel(); return; }
      if (charIndex < word.length) {
        setState(() => _hintDisplay = word.substring(0, ++charIndex));
      } else {
        timer.cancel();
        _hintTimer = Timer(const Duration(seconds: 2), () {
          if (mounted) _eraseHint(word);
        });
      }
    });
  }

  void _eraseHint(String word) {
    int charIndex = word.length;
    _hintTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      if (!mounted) { timer.cancel(); return; }
      if (charIndex > 0) {
        setState(() => _hintDisplay = word.substring(0, --charIndex));
      } else {
        timer.cancel();
        _hintIndex = (_hintIndex + 1) % _hints.length;
        _hintTimer = Timer(const Duration(milliseconds: 300), () {
          if (mounted) _typeNext();
        });
      }
    });
  }

  @override
  void dispose() {
    _hideOverlay();
    _hintTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  TextDirection _detectDirection(String text) {
    return isArabic(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  void _onChanged(String value) {
    setState(() {
      _textDirection = _detectDirection(value);
    });
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final trimmed = value.trim();
      final mode = ref.read(searchModeProvider);
      // Update suggestion provider for keyword mode dropdown
      ref.read(suggestionQueryProvider.notifier).set(trimmed);
      // For full-text mode, also update the main search query
      if (mode == SearchMode.fullText) {
        _lastSetQuery = trimmed;
        ref.read(searchQueryProvider.notifier).set(trimmed);
      }
      _updateOverlay();
    });
  }

  void _onSubmitted(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      _lastSetQuery = trimmed;
      ref.read(searchHistoryProvider.notifier).add(trimmed);
      ref.read(searchQueryProvider.notifier).set(trimmed);
    }
    _focusNode.unfocus();
    _hideOverlay();
  }

  void _selectHistory(String query) {
    _hideOverlay();
    _focusNode.unfocus();
    // Look up the word — it might be a derivative, not a root
    ref.read(repositoryProvider).searchByWord(query).then((results) {
      final exact = results.where((e) => e.word == query).toList();
      if (exact.isEmpty) {
        // Fallback: navigate as root (may show "not found" for truly missing words)
        if (mounted) context.push('/entry/$query');
        return;
      }
      final entry = exact.first;
      if (mounted) {
        if (entry.isRoot) {
          context.push('/entry/${entry.word}');
        } else {
          ref.read(repositoryProvider).getEntry(entry.parentId).then((parent) {
            if (parent != null && mounted) {
              context.push('/entry/${parent.word}?highlight=${entry.id}');
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(searchModeProvider);
    final cs = Theme.of(context).colorScheme;

    // Sync controller when query is cleared externally (e.g. home button)
    final providerQuery = ref.watch(searchQueryProvider);
    if (providerQuery.isEmpty && _lastSetQuery.isNotEmpty) {
      _lastSetQuery = '';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.text.isNotEmpty) {
          _controller.clear();
          ref.read(suggestionQueryProvider.notifier).set('');
          setState(() => _textDirection = TextDirection.ltr);
        }
      });
    }

    final searchField = Padding(
      padding: const EdgeInsets.only(left: 36, right: 36),
      child: CompositedTransformTarget(
        link: _layerLink,
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onChanged,
          onSubmitted: _onSubmitted,
          textInputAction: TextInputAction.search,
          textDirection: _textDirection,
          textAlign: _textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left,
          decoration: InputDecoration(
            hintText: mode == SearchMode.keyword ? 'Search $_hintDisplay' : 'Full text search...',
            hintTextDirection: TextDirection.ltr,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      _lastSetQuery = '';
                      ref.read(searchQueryProvider.notifier).set('');
                      ref.read(suggestionQueryProvider.notifier).set('');
                      setState(() => _textDirection = TextDirection.ltr);
                      _updateOverlay();
                    },
                  )
                : null,
            filled: true,
            fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
    );

    final segmented = SegmentedButton<SearchMode>(
      segments: const [
        ButtonSegment(value: SearchMode.keyword, label: Text('Keyword'), icon: Icon(Icons.key, size: 16)),
        ButtonSegment(value: SearchMode.fullText, label: Text('Full Text'), icon: Icon(Icons.text_fields, size: 16)),
      ],
      selected: {mode},
      onSelectionChanged: (s) {
        ref.read(searchModeProvider.notifier).set(s.first);
        // When switching to full text, trigger search immediately if there's text
        final trimmed = _controller.text.trim();
        if (s.first == SearchMode.fullText && trimmed.isNotEmpty) {
          _lastSetQuery = trimmed;
          ref.read(searchQueryProvider.notifier).set(trimmed);
        } else if (s.first == SearchMode.keyword) {
          // Clear main search results, suggestions handle it
          _lastSetQuery = '';
          ref.read(searchQueryProvider.notifier).set('');
          ref.read(suggestionQueryProvider.notifier).set(trimmed);
        }
        _updateOverlay();
      },
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.labelMedium),
      ),
    );

    final isBottom = ref.watch(searchBarBottomProvider).value ?? false;
    final children = isBottom
        ? [segmented, const SizedBox(height: 6), searchField]
        : [searchField, const SizedBox(height: 6), segmented];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
