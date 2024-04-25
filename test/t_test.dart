// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';

void main() {
  // test('t_test.dart', () {
  //   // test code
  //   // log(Uri(path: 'path', queryParameters: {'q': 'text'}).toString());

  //   final base = {
  //     1: 'text',
  //     2: 'text2',
  //     4: 'text4',
  //   };

  //   print('before: $base');
  //   base.addAll({
  //     2: 'text222',
  //     5: 'text5',
  //   });

  //   print('after: $base');
  // });
  // test('t_test.dart baseUrl', () {
  //   // test code
  //   // log(Uri(path: 'path', queryParameters: {'q': 'text'}).toString());

  //   const path = '/api/search/product/shop/:shopId/sort';
  //   final url = baseUri(path: path, pathVariables: {
  //     'shopId': '123',
  //   }).toString();

  //   print(url);
  // });
  test('t_test.dart baseUrl', () {
    // test list int?

    List<int?> followedShopIds = [null, 1, null, 3, 4];

    print('before: $followedShopIds');

    followedShopIds[0] = 1;
    followedShopIds[4] = null;

    print('after: $followedShopIds');
  });
}
