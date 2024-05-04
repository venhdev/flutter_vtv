// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:vtv_common/core.dart';

import 'search_history_entity.dart';

class SearchHistoryResp extends IBasePageResp<SearchHistoryEntity> {
  const SearchHistoryResp({
    required super.items,
    super.count,
    super.page,
    super.size,
    super.totalPage,
  });

  SearchHistoryResp copyWith({
    List<SearchHistoryEntity>? items,
    int? count,
    int? page,
    int? size,
    int? totalPage,
  }) {
    return SearchHistoryResp(
      items: items ?? this.items,
      count: count ?? this.count,
      page: page ?? this.page,
      size: size ?? this.size,
      totalPage: totalPage ?? this.totalPage,
    );
  }

  List<String> get searchHistories => items.map((e) => e.search).toList();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'searchHistoryDTOs': items.map((x) => x.toMap()).toList(),
      'count': count,
      'page': page,
      'size': size,
      'totalPage': totalPage,
    };
  }

  factory SearchHistoryResp.fromMap(Map<String, dynamic> map) {
    return SearchHistoryResp(
      items: List<SearchHistoryEntity>.from(
        (map['searchHistoryDTOs'] as List<dynamic>).map<SearchHistoryEntity>(
          (x) => SearchHistoryEntity.fromMap(x as Map<String, dynamic>),
        ),
      ),
      count: map['count'] != null ? map['count'] as int : null,
      page: map['page'] != null ? map['page'] as int : null,
      size: map['size'] != null ? map['size'] as int : null,
      totalPage: map['totalPage'] != null ? map['totalPage'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchHistoryResp.fromJson(String source) =>
      SearchHistoryResp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SearchHistoryResp(items: $items, count: $count, page: $page, size: $size, totalPage: $totalPage)';
  }

  @override
  bool operator ==(covariant SearchHistoryResp other) {
    if (identical(this, other)) return true;

    return listEquals(other.items, items) &&
        other.count == count &&
        other.page == page &&
        other.size == size &&
        other.totalPage == totalPage;
  }

  @override
  int get hashCode {
    return items.hashCode ^ count.hashCode ^ page.hashCode ^ size.hashCode ^ totalPage.hashCode;
  }
}
