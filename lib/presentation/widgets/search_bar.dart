import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Timer? _debounce;
  bool _showHistory = false;
  TextDirection _textDirection = TextDirection.ltr;
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.platformDispatcher.views.first.viewInsets.bottom;
    final wasVisible = _keyboardVisible;
    _keyboardVisible = bottomInset > 0;
    // Only react when keyboard was open and is now closed
    if (wasVisible && !_keyboardVisible && _showHistory) {
      _focusNode.unfocus();
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      setState(() => _showHistory = true);
    } else {
      // Delay hiding so taps on history items can register first
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_focusNode.hasFocus) {
          setState(() => _showHistory = false);
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  TextDirection _detectDirection(String text) {
    if (text.isEmpty) return TextDirection.ltr;
    final firstChar = text.codeUnitAt(0);
    // Arabic Unicode range
    if (firstChar >= 0x0600 && firstChar <= 0x06FF ||
        firstChar >= 0x0750 && firstChar <= 0x077F ||
        firstChar >= 0xFB50 && firstChar <= 0xFDFF ||
        firstChar >= 0xFE70 && firstChar <= 0xFEFF) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }

  void _onChanged(String value) {
    setState(() {
      _textDirection = _detectDirection(value);
      _showHistory = _focusNode.hasFocus;
    });
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(searchQueryProvider.notifier).set(value.trim());
    });
  }

  void _onSubmitted(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      ref.read(searchHistoryProvider.notifier).add(trimmed);
      ref.read(searchQueryProvider.notifier).set(trimmed);
    }
    _focusNode.unfocus();
    setState(() => _showHistory = false);
  }

  void _selectHistory(String query) {
    _controller.text = query;
    _controller.selection = TextSelection.collapsed(offset: query.length);
    _textDirection = _detectDirection(query);
    ref.read(searchQueryProvider.notifier).set(query);
    setState(() => _showHistory = false);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(searchModeProvider);
    final cs = Theme.of(context).colorScheme;
    final history = ref.watch(searchHistoryProvider).value ?? [];
    final isBottom = ref.watch(searchBarBottomProvider).value ?? false;

    final searchField = Padding(
      padding: const EdgeInsets.only(left: 36, right: 36),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: _onChanged,
        onSubmitted: _onSubmitted,
        textInputAction: TextInputAction.search,
        textDirection: _textDirection,
        textAlign: _textDirection == TextDirection.rtl ? TextAlign.right : TextAlign.left,
        decoration: InputDecoration(
          hintText: mode == SearchMode.keyword ? 'Search Arabic word...' : 'Full text search...',
          hintTextDirection: TextDirection.ltr,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    ref.read(searchQueryProvider.notifier).set('');
                    setState(() {
                      _textDirection = TextDirection.ltr;
                      _showHistory = _focusNode.hasFocus;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
      },
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        textStyle: WidgetStatePropertyAll(Theme.of(context).textTheme.labelMedium),
      ),
    );

    final query = _controller.text.trim();
    final filteredHistory = query.isEmpty
        ? history.take(5).toList()
        : history.where((h) => h.contains(query)).toList();

    final historyWidget = (_showHistory && filteredHistory.isNotEmpty)
        ? _buildHistory(cs, filteredHistory)
        : const SizedBox.shrink();

    // Top: searchField, tabs, history
    // Bottom (reversed): history, tabs, searchField
    final children = isBottom
        ? [historyWidget, const SizedBox(height: 6), segmented, const SizedBox(height: 6), searchField]
        : [searchField, const SizedBox(height: 6), segmented, historyWidget];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }

  Widget _buildHistory(ColorScheme cs, List<String> items) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      constraints: const BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 4),
        itemCount: items.length,
        itemBuilder: (_, i) => ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          leading: Icon(Icons.history, size: 18, color: cs.onSurfaceVariant),
          title: Text(items[i], textDirection: _detectDirection(items[i])),
          trailing: IconButton(
            icon: Icon(Icons.close, size: 16, color: cs.onSurfaceVariant),
            onPressed: () => ref.read(searchHistoryProvider.notifier).remove(items[i]),
          ),
          onTap: () => _selectHistory(items[i]),
        ),
      ),
    );
  }
}
