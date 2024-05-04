// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SearchHistoryEntity {
  final String searchHistoryId;
  final String search;
  final DateTime createAt;

  SearchHistoryEntity({
    required this.searchHistoryId,
    required this.search,
    required this.createAt,
  });
  factory SearchHistoryEntity.fromQuery(String query) => SearchHistoryEntity(
        searchHistoryId: DateTime.now().toString(),
        search: query,
        createAt: DateTime.now(),
      );

  SearchHistoryEntity copyWith({
    String? searchHistoryId,
    String? search,
    DateTime? createAt,
  }) {
    return SearchHistoryEntity(
      searchHistoryId: searchHistoryId ?? this.searchHistoryId,
      search: search ?? this.search,
      createAt: createAt ?? this.createAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'searchHistoryId': searchHistoryId,
      'search': search,
      'createAt': createAt.toIso8601String(),
    };
  }

  factory SearchHistoryEntity.fromMap(Map<String, dynamic> map) {
    return SearchHistoryEntity(
      searchHistoryId: map['searchHistoryId'] as String,
      search: map['search'] as String,
      createAt: DateTime.parse(map['createAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchHistoryEntity.fromJson(String source) =>
      SearchHistoryEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SearchHistoryEntity(searchHistoryId: $searchHistoryId, search: $search, createAt: $createAt)';

  @override
  bool operator ==(covariant SearchHistoryEntity other) {
    if (identical(this, other)) return true;

    return other.searchHistoryId == searchHistoryId && other.search == search && other.createAt == createAt;
  }

  @override
  int get hashCode => searchHistoryId.hashCode ^ search.hashCode ^ createAt.hashCode;
}
