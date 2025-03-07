import 'package:chat_sdk/consts.dart';
import 'package:flutter/material.dart';

class SearchPage extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Search for contact ..';

  @override
  TextStyle? get searchFieldStyle => const TextStyle(
        color: Colors.black, // Hint text color
        fontSize: 20,
      );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        toolbarHeight: 65,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        hintStyle: TextStyle(
          color: Colors.grey, // Hint text color
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: baseColor1),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: baseColor1),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = contactsList
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      color: baseGroundColor, // Background for results
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 5, left: 8, right: 8),
        itemCount: results.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              results[index],
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              close(context, results[index]);
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? contactsList
        : contactsList
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return Container(
      color: baseGroundColor,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 5, left: 8, right: 8),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              suggestions[index],
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              query = suggestions[index];
              showResults(context);
            },
          );
        },
      ),
    );
  }
}
