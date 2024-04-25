import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/vtv_common.dart';

import '../../../../auth/presentation/components/rating.dart';
import '../../pages/review_detail_page.dart';

class ReviewItem extends StatelessWidget {
  const ReviewItem(
    this.review, {
    super.key,
  });

  final ReviewEntity review;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //# user info + rating
        ListTile(
          leading: const CircleAvatar(
            // backgroundImage: NetworkImage(ok.data.reviews[index].userAvatar),
            backgroundImage: AssetImage('assets/images/placeholders/a1.png'),
          ),
          title: Text(review.username),
          subtitle: Rating(rating: double.parse(review.rating.toString())),
        ),

        //# review content
        Text(review.content),

        //# review image
        if (review.image != null)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoViewPage(imageUrl: review.image!),
                ),
              );
            },
            child: SizedBox(
              height: 100,
              child: ImageCacheable(
                review.image!,
                fit: BoxFit.cover,
              ),
            ),
          ),

        // count comment
        // Text(
        //   'Bình luận (${review.countComment})',
        //   style: const TextStyle(
        //     color: Colors.grey,
        //     fontSize: 12,
        //   ),
        // ),

        //#  date, comment
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              StringHelper.convertDateTimeToString(
                (review.createdAt).toLocal(),
                pattern: 'dd-MM-yyyy hh:mm aa',
              ),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            Badge(
              label: Text(review.countComment.toString()),
              offset: const Offset(0, 0),
              backgroundColor: Colors.blueGrey,
              child: IconButton(
                icon: const Icon(Icons.comment),
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  context.push(
                    '${ReviewDetailPage.path}/${review.reviewId}',
                    extra: review,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
