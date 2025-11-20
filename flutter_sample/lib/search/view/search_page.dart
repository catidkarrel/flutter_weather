import 'package:flutter/material.dart';

/// Class definition for search page
class SearchPage extends StatefulWidget {
  /// Private constructor for search page
  const SearchPage._();

  /// Route for search page
  static Route<String> route() {
    return MaterialPageRoute(builder: (_) => const SearchPage._());
  }

  /// State for search page
  @override
  State<SearchPage> createState() => _SearchPageState();
}

/// State for search page
class _SearchPageState extends State<SearchPage> {
  /// Text controller for search page
  final TextEditingController _textController = TextEditingController();

  /// Text for search page
  String get _text => _textController.text;

  /// Dispose method for search page
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  /// Build method for search page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('City Search')),
      body: Row(
        children: [
          /// Expanded text field for search page
          Expanded(child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Tokyo',
              ),
            ),
          ),
          ),
          /// Search button for search page
          IconButton(
            key: const Key('searchPage_search_iconButton'),
            icon: const Icon(Icons.search, semanticLabel: 'Submit'),
            onPressed: () => Navigator.of(context).pop(_text),
          )
        ],
      )
    );
  }
}
