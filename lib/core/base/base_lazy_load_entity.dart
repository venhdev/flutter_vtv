import 'package:equatable/equatable.dart';

abstract class IBasePageResp<T> extends Equatable {
  const IBasePageResp({
    required this.listItem,
    required this.count,
    required this.page,
    required this.size,
    required this.totalPage,
  });

  final List<T> listItem;
  final int count;
  final int page;
  final int size;
  final int totalPage;

  @override
  List<Object?> get props => [
        listItem,
        count,
        page,
        size,
        totalPage,
      ];
}
