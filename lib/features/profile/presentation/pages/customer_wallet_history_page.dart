import 'package:flutter/material.dart';
import 'package:flutter_vtv/features/order/domain/repository/order_repository.dart';
import 'package:vtv_common/wallet.dart';

import '../../../../service_locator.dart';

class CustomerWalletHistoryPage extends StatelessWidget {
  const CustomerWalletHistoryPage({super.key});

  static const routeName = 'transaction-history';
  static const path = '/user/transaction-history';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch sử giao dịch'),
      ),
      body: TransactionHistory(
        dataCallback: sl<OrderRepository>().getWalletTransactionHistory(),
      ),
    );
  }
}
