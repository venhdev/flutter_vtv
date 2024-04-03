import 'package:flutter/material.dart';

import '../../../../core/helpers/converter.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationItem extends StatefulWidget {
  const NotificationItem({
    super.key,
    required this.notification,
  });

  final NotificationEntity notification;

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool showDetail = false;

  @override
  Widget build(BuildContext context) {
    return Badge(
      offset: const Offset(-18, 0),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
      isLabelVisible: widget.notification.seen,
      label: const Text(
        'Mới',
        style: TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //# image
            // SizedBox(
            //   width: 50,
            //   height: 50,
            //   child: const ImageCacheable(
            //     widget.notification.image,
            //   ),
            // ),

            // SizedBox(width: 8),

            // # title & body
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    // notification.title,
                    widget.notification.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    // notification.body,
                    widget.notification.body,
                    maxLines: showDetail ? null : 2,
                    overflow: showDetail ? null : TextOverflow.ellipsis,
                  ),
                  // # time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // notification.createAt.toString(),
                        convertDateTimeToString(
                          widget.notification.createAt,
                          pattern: 'dd/MM/yyyy HH:mm',
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      // # expand button
                      InkWell(
                        onTap: () {
                          setState(() {
                            showDetail = !showDetail;
                          });
                        },
                        child: Icon(showDetail ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
