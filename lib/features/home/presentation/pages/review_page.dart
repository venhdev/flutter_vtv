import 'package:flutter/material.dart';

import '../../domain/dto/review_resp.dart';

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key, required this.reviewResp});

  final ReviewResp reviewResp;

  @override
  Widget build(BuildContext context) {
    return const Text('Review Page');
  }
}
