import 'package:flutter/material.dart';
import 'package:flutter_vtv/core/constants/typedef.dart';
import 'package:flutter_vtv/core/notification/local_notification_manager.dart';
import 'package:flutter_vtv/features/home/domain/dto/product_detail_resp.dart';
import 'package:flutter_vtv/features/order/presentation/pages/purchase_page.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/components/custom_widgets.dart';
import '../../../../service_locator.dart';
import '../../../home/domain/repository/product_repository.dart';
import '../../../home/presentation/components/product_components/product_list_builder.dart';
import '../../../order/presentation/pages/voucher_page.dart';
import '../../../profile/presentation/pages/user_detail_page.dart';
import '../../domain/entities/auth_entity.dart';
import '../../../../core/presentation/components/app_bar.dart';

class LoggedView extends StatelessWidget {
  const LoggedView({
    super.key,
    required this.auth,
  });

  final AuthEntity auth;

  // appBar: buildAppBar(context, showSettingButton: true, showSearchBar: false, title: 'User'),

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return _buildHeaderSliver(context);
      },
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.go(PurchasePage.path);
              },
              child: const Text('Đơn hàng của tôi'),
            ),

            //# Recent Product Viewed
            _buildRecentProduct(),

            // voucher
            //! DEV
            const Divider(height: 32, thickness: 1, color: Colors.red),
            const Text('DEV'),
            ElevatedButton(
              onPressed: () {
                // debugPrint('text');
                context.go(VoucherPage.path);
              },
              child: const Text('All Vouchers'),
            ),

            ElevatedButton(
              onPressed: () {
                sl<LocalNotificationManager>().showNotification(
                  id: 1,
                  title: 'Title',
                  body: 'Body',
                );
              },
              child: const Text('Notification'),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<Result<List<ProductDetailResp>>> _buildRecentProduct() {
    return FutureBuilder(
            future: sl<ProductRepository>().getRecentViewedProducts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final resultEither = snapshot.data!;
                return resultEither.fold(
                  (error) {
                    return MessageScreen.error(error.toString());
                  },
                  (data) {
                    return SizedBox(
                      height: 100,
                      child: ProductDetailListBuilder(
                        productDetails: data,
                        crossAxisCount: 1,
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
  }

  List<Widget> _buildHeaderSliver(BuildContext context) {
    return [
      SliverAppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
        actions: [
          const CartBadge(),
          IconButton(
            onPressed: () => context.go('/user/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      SliverToBoxAdapter(
        child: IconButton(
          // no border
          style: IconButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
          ),
          padding: EdgeInsets.zero,
          onPressed: () => context.go(UserDetailPage.path, extra: auth.userInfo),
          icon: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              // avatar
              children: [
                const SizedBox(width: 12),
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/placeholders/a1.png'),
                ),

                const SizedBox(width: 12),

                // username
                SizedBox(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${auth.userInfo.fullName!} (${auth.userInfo.username!})',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }
}
