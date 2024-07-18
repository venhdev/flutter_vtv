import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../../../service_locator.dart';
import '../../domain/repository/order_repository.dart';
import '../components/voucher_item.dart';
import 'voucher_collection_page.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({
    this.title = 'Danh sách voucher',
    super.key,
    this.returnValue = false,
    this.future,
    this.canFindMore = false,
  });

  static const String routeName = 'voucher';
  static const String path = '/user/voucher';

  final String title;
  final bool returnValue;
  final FRespData<List<VoucherEntity>>? future;

  final bool canFindMore;

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.title),
        actions: [
          // refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: widget.future != null ? widget.future! : sl<OrderRepository>().voucherListAll(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final respEither = snapshot.data!;
              return respEither.fold(
                (error) {
                  return MessageScreen.error(error.message);
                },
                (ok) {
                  if (ok.data!.isEmpty) {
                    return widget.canFindMore
                        ? MessageScreen(
                            message: 'Không tìm thấy voucher nào!',
                            buttonLabel: 'Tìm thêm voucher',
                            onPressed: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const VoucherCollectionPage();
                                  },
                                ),
                              );

                              setState(() {});
                            },
                          )
                        : MessageScreen(
                            message: 'Không tìm thấy voucher nào!',
                            buttonLabel: 'Quay lại',
                            onPressed: () => Navigator.of(context).pop(),
                          );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: ListView.builder(
                      itemCount: ok.data!.length,
                      itemBuilder: (context, index) {
                        return VoucherItemV2(
                          voucher: ok.data![index],
                          onPressed: (voucher) {
                            if (voucher.quantityUsed != null) {
                              if ((voucher.quantityUsed! < voucher.quantity)) {
                                if (widget.returnValue) Navigator.of(context).pop(voucher);
                              } else {
                                Fluttertoast.showToast(msg: 'Voucher đã hết lượt sử dụng!');
                              }
                            }
                          },
                          actionLabel: 'Áp dụng',
                          // onActionPressed: (voucher) {
                          //   if (returnValue) Navigator.of(context).pop(voucher);
                          // },
                        );
                      },
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
