import 'package:flutter/material.dart';
import 'package:vtv_common/vtv_common.dart';

class OrderItem extends StatelessWidget {
  const OrderItem(
    this.item, {
    super.key,
  });

  final OrderItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Image
        SizedBox(
          width: 100,
          height: 100,
          child: Image.network(
            item.productVariant.image.isNotEmpty ? item.productVariant.image : item.productVariant.productImage,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error);
            },
          ),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  item.productVariant.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),

                // SKU
                Text('Phân loại: ${item.productVariant.sku}'),

                // Price x Quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StringHelper.formatCurrency(item.productVariant.price),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Số lượng: ${item.quantity}',
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
