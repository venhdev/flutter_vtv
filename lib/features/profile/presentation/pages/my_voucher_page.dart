import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';

import '../../../../service_locator.dart';
import '../../../order/domain/repository/voucher_repository.dart';
import '../../../order/presentation/components/voucher_item.dart';
import '../../../order/presentation/pages/voucher_collection_page.dart';

class MyVoucherPage extends StatefulWidget {
  const MyVoucherPage({super.key});

  static const String routeName = 'my-voucher';
  static const String path = '/user/my-voucher';

  @override
  State<MyVoucherPage> createState() => _MyVoucherPageState();
}

class _MyVoucherPageState extends State<MyVoucherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher của tôi'),
      ),
      body: Column(
        children: [
          // btn find more voucher
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ElevatedButton.icon(
              onPressed: () async {
                await context.push(VoucherCollectionPage.path);
                setState(() {});
              },
              icon: const Icon(Icons.add_card),
              label: const Text('Tìm thêm voucher'),
            ),
          ),

          Expanded(
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state.status == AuthStatus.authenticated) {
                  return FutureBuilder(
                    future: sl<VoucherRepository>().customerVoucherList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!.fold(
                          (error) => MessageScreen.error(error.message),
                          (ok) {
                            if (ok.data!.isEmpty) {
                              return const MessageScreen(
                                message: 'Bạn chưa lưu voucher nào!',
                              );
                            }
                            final voucherList = ok.data!;
                            return RefreshIndicator(
                              onRefresh: () async {
                                setState(() {});
                              },
                              child: ListView.builder(
                                itemCount: voucherList.length,
                                itemBuilder: (context, index) => Dismissible(
                                  key: Key(voucherList[index].voucherId.toString()),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    sl<VoucherRepository>()
                                        .customerVoucherDelete(voucherList[index].voucherId)
                                        .then((respEither) {
                                      log(respEither.toString());
                                      respEither.fold(
                                        (error) => log(error.message ?? 'Xóa thất bại'),
                                        (ok) {
                                          voucherList.removeAt(index);
                                          log(ok.message ?? 'Xóa thành công');
                                        },
                                      );
                                    });
                                  },
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: VoucherItemV2(
                                    voucher: ok.data![index],
                                    actionLabel: 'Xem',
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return MessageScreen.error(snapshot.error.toString());
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
