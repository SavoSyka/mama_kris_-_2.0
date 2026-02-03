import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/theme/app_theme.dart';

class HomeSearchPage extends StatefulWidget {
  const HomeSearchPage({super.key});

  @override
  State<HomeSearchPage> createState() => _HomeSearchPageState();
}

class _HomeSearchPageState extends State<HomeSearchPage> {
  final TextEditingController _controller = TextEditingController(
    text: "Менеджер по закупке рекламы",
  );
  final FocusNode _focusNode = FocusNode();

  // ---------- DEBOUNCE ----------
  Timer? _debounce;
  static const _debounceDuration = Duration(milliseconds: 500);

  // ---------- SUGGESTIONS ----------
  final List<String> _staticSuggestions = [
    'devloper',
    'flutter',
    'fl',
    'hydr',
    'midroc',
  ];

  // You will replace this with real API results
  List<String> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus(); // auto-focus when page opens
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(_debounceDuration, () {
      final query = _controller.text.trim();
      if (query.isEmpty) {
        setState(() => _searchResults = []);
        return;
      }

      // ----- CALL YOUR API HERE -----
      // final results = await YourApi.searchJobs(query);
      // setState(() => _searchResults = results.map((e) => e.title).toList());

      // ----- DEMO: filter static list -----
      setState(() {
        _searchResults = _staticSuggestions
            .where((s) => s.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    });
  }

  void _submit() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) Navigator.pop(context, query);
  }

  void _onSuggestionTap(String suggestion) {
    Navigator.pop(context, suggestion);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.transparent,
        centerTitle: false,

        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _submit(),
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Search jobs...',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Color(0xFfF6FEF7),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _controller.clear();
                        setState(() => _searchResults = []);
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
      // // ---- same gradient as bottom-sheet ----
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              const Divider(height: 1, color: Colors.white24),

              // ---------- RESULTS / SUGGESTIONS ----------
              Expanded(
                child: _searchResults.isNotEmpty
                    ? ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, i) {
                          final item = _searchResults[i];
                          return ListTile(
                            leading: const Icon(
                              Icons.search,
                              color: Colors.black54,
                            ),
                            title: Text(
                              item,
                              style: const TextStyle(color: Colors.black),
                            ),
                            onTap: () => _onSuggestionTap(item),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: _staticSuggestions.length,
                        itemBuilder: (context, i) {
                          final suggestion = _staticSuggestions[i];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            leading: const Icon(
                              Icons.history,
                              color: Colors.black54,
                            ),
                            title: Text(
                              suggestion,
                              style: const TextStyle(color: Colors.black),
                            ),
                            trailing: const Icon(
                              Icons.close,
                              color: Colors.black54,
                            ),
                            onTap: () => _onSuggestionTap(suggestion),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
