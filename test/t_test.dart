import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('t_test.dart', () {
    // test code
    log(Uri(path: 'path', queryParameters: {'q': 'text'}).toString());
  });
}