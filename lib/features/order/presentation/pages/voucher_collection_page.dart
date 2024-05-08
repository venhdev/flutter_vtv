import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/voucher_repository.dart';
import '../components/voucher_item.dart';

class VoucherCollectionPage extends StatelessWidget {
  const VoucherCollectionPage({super.key});

  static const String routeName = 'voucher-collection';
  static const String path = '/home/voucher-collection';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm thêm voucher'),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            return FutureBuilder(
              future: sl<VoucherRepository>().listOnSystem(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.fold(
                    (error) => MessageScreen.error(error.message),
                    (ok) {
                      if (ok.data!.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return ListView.builder(
                        itemCount: ok.data!.length,
                        itemBuilder: (context, index) => VoucherItemV2(
                          voucher: ok.data![index],
                          actionLabel: 'Lưu',
                          onActionPressed: (voucher) {
                            sl<VoucherRepository>().customerVoucherSave(voucher.voucherId).then((respEither) {
                              respEither.fold(
                                (error) => Fluttertoast.showToast(msg: error.message ?? 'Lưu thất bại'),
                                (ok) => Fluttertoast.showToast(msg: ok.message ?? 'Lưu thành công'),
                              );
                            });
                          },
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
    );
  }
}
