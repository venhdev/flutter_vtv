import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../../../service_locator.dart';
import '../../../domain/entities/search_history_entity.dart';
import '../../../domain/repository/search_product_repository.dart';

class CustomerSearchDelegate extends SearchDelegate<SearchHistoryEntity> {
  final List<SearchHistoryEntity> searchList;
  CustomerSearchDelegate({required this.searchList});

  // This method is responsible for building actions in the AppBar, such as a clear button.
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      // Clear button
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            // When pressed here the query will be cleared from the search bar.
            query = '';
          },
        ),

      // Search button
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Perform search operation here.
            // showResults(context);
            close(context, SearchHistoryEntity.fromQuery(query));
          },
        ),
    ];
  }

  // The buildLeading method defines the leading icon or button. Typically, this is a back button.
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
      // Exit from the search screen.
    );
  }

  // This method is responsible for displaying the search results. customize it according to app.
  @override
  Widget buildResults(BuildContext context) {
    // final List<String> searchResults = searchList
    //     .where(
    //       (item) => item.search.toLowerCase().contains(query.toLowerCase()),
    //     )
    //     .toList();

    final List<String> searchResults = searchList
        .map((e) => e.search)
        .where(
          (item) => item.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    log('searchResults: $searchResults');
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(searchResults[index]),
          onTap: () {
            // Handle the selected search result.
            // close(context, searchResults[index]);
            // query = searchResults[index];
            close(context, SearchHistoryEntity.fromQuery(searchResults[index]));
          },
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              query = searchResults[index];
              // Show the search results based on the selected suggestion.
            },
          ),
        );
      },
    );
  }

  // The buildSuggestions method is used to provide search suggestions as the user types.
  // You can fetch suggestions from your data source and display them here.
  @override
  Widget buildSuggestions(BuildContext context) {
    // final List<String> suggestionList = query.isEmpty
    //     ? searchList
    //     : searchList
    //         .where(
    //           (item) => item.toLowerCase().contains(query.toLowerCase()),
    //         )
    //         .toList();

    final List<SearchHistoryEntity> suggestionList = searchList
        // .map((e) => e.search)
        .where(
          (item) => item.search.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    log('suggestionList: $suggestionList');

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index].search),
          onTap: () {
            // query = suggestionList[index];
            // Show the search results based on the selected suggestion.
            close(context, SearchHistoryEntity.fromQuery(suggestionList[index].search));
          },
          onLongPress: () async {
            // Remove the selected suggestion from the search history.
            // show dropdown menu to delete
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Xóa lịch sử tìm kiếm'),
                  content: Text('Bạn có chắc chắn muốn xóa "${suggestionList[index].search}" không?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        searchList
                            .removeWhere((element) => element.searchHistoryId == suggestionList[index].searchHistoryId);
                        sl<SearchProductRepository>().searchHistoryDelete(suggestionList[index].searchHistoryId);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Xóa'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Hủy'),
                    ),
                  ],
                );
              },
            ).then((value) => query = query);

            // showDialogToConfirm(
            //   context: context,
            //   title: 'Xóa lịch sử tìm kiếm',
            //   content: 'Bạn có chắc chắn muốn xóa "${suggestionList[index].search}" không?',
            //   onConfirm: () {
            //     searchList.removeWhere((element) => element.searchHistoryId == suggestionList[index].searchHistoryId);
            //     sl<SearchProductRepository>().searchHistoryDelete(suggestionList[index].searchHistoryId);
            //   },
            //   confirmText: 'Xóa',
            //   dismissText: 'Hủy',
            // );
          },
          leading: const Icon(Icons.history),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              query = suggestionList[index].search;
              // Show the search results based on the selected suggestion.
              // showResults(context);
            },
          ),
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          appBarTheme: Theme.of(context).appBarTheme.copyWith(
                color: Theme.of(context).colorScheme.background,
              ),
        );
  }

  @override
  String get searchFieldLabel => 'Tìm kiếm...';

  // on Submitted Text Field
  @override
  void showResults(BuildContext context) {
    super.showResults(context);
    close(context, SearchHistoryEntity.fromQuery(query));
  }
}
