import 'package:flutter/material.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/profile.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/profile_repository.dart';

class LoyaltyPointHistoryPage extends StatelessWidget {
  const LoyaltyPointHistoryPage({super.key, required this.loyaltyPointId});

  final int loyaltyPointId;
  static const routeName = 'loyalty-point-history';
  static const path = '/user/loyalty-point-history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử điểm thưởng'),
      ),
      body: FutureBuilder(
        future: sl<ProfileRepository>().getLoyaltyPointHistory(loyaltyPointId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final resultEither = snapshot.data!;
            return resultEither.fold(
              (error) => MessageScreen.error(error.message),
              (ok) => Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mô tả'),
                        Text('Biến động điểm'),
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: ok.data!.length,
                      itemBuilder: (context, index) =>
                          LoyaltyPointHistoryItem(loyaltyPointHistoryEntity: ok.data![index]),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return MessageScreen.error(snapshot.error.toString());
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class LoyaltyPointHistoryItem extends StatelessWidget {
  const LoyaltyPointHistoryItem({super.key, required this.loyaltyPointHistoryEntity});
  // final int? loyaltyPointHistoryId;
  // final int point;
  // final String? type;
  // final String? status;
  // final int loyaltyPointId;
  // final DateTime? createAt;
  final LoyaltyPointHistoryEntity loyaltyPointHistoryEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: ListTile(
        style: ListTileStyle.list,
        title: Text(getTypeName(loyaltyPointHistoryEntity.type)),
        subtitle: Text(
            ConversionUtils.convertDateTimeToString(
              loyaltyPointHistoryEntity.createAt!,
              pattern: 'dd/MM/yyyy hh:mm aa',
            ),
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Text(
          loyaltyPointHistoryEntity.point.isNegative
              ? loyaltyPointHistoryEntity.point.toString()
              : '+${loyaltyPointHistoryEntity.point}',
          style: TextStyle(
            color: loyaltyPointHistoryEntity.point.isNegative ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

String getTypeName(String? type) {
  switch (type) {
    case 'REWARD':
      return 'Đổi quà';
    case 'SHARE':
      return 'Chia sẻ';
    case 'REVIEW':
      return 'Thưởng đánh giá';
    case 'PURCHASE':
      return 'Mua hàng';
    case 'PAYMENT':
      return 'Thanh toán đơn hàng';
    case 'REFUND':
      return 'Hoàn tiền';
    default:
      return type ?? 'Khác';
  }
}
