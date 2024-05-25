import 'package:flutter/material.dart';
import 'package:flutter_vtv/features/home/data/data_sources/local_product_data_source.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:vtv_common/auth.dart';
import 'package:vtv_common/core.dart';
import 'package:vtv_common/home.dart';
import 'package:vtv_common/order.dart';

import '../../../../service_locator.dart';
import '../../../cart/presentation/components/cart_badge.dart';
import '../../../chat/presentation/pages/customer_chat_room_page.dart';
import '../../../home/domain/repository/product_repository.dart';
import '../../../home/presentation/components/product/product_page_builder.dart';
import '../../../home/presentation/pages/favorite_products_page.dart';
import '../../../home/presentation/pages/product_detail_page.dart';
import '../../../profile/domain/repository/profile_repository.dart';
import '../../../profile/presentation/pages/followed_shop_page.dart';
import '../../../profile/presentation/pages/user_detail_page.dart';
import '../pages/customer_wallet_history_page.dart';
import '../pages/loyalty_point_history_page.dart';
import '../pages/my_voucher_page.dart';

class LoggedView extends StatefulWidget {
  const LoggedView({
    super.key,
    required this.auth,
  });

  final AuthEntity auth;

  @override
  State<LoggedView> createState() => _LoggedViewState();
}

class _LoggedViewState extends State<LoggedView> {
  bool _loading = true;
  late List<ProductDetailResp> _recentViewedProduct;

  void loadRecentViewed() {
    sl<ProductRepository>().getRecentViewedProducts().then((value) {
      if (mounted) {
        setState(() {
          _loading = false;
          _recentViewedProduct = value.fold(
            (error) => [],
            (ok) => ok,
          );
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadRecentViewed();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return _buildHeaderSliver(context);
      },
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loading = true;
            loadRecentViewed();
          });
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //# My Voucher + Customer Wallet
              _customerWidgets(context),

              //# My Purchase
              _buildMyPurchase(context),

              //# Favorite product
              _buildFavoriteProduct(context),

              //# Recent Product Viewed
              _buildRecentProduct(),

              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(Icons.logo_dev),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoriteProduct(BuildContext context) {
    return CatalogItem(
      catalogName: 'Sản phẩm yêu thích',
      catalogDescription: 'Xem tất cả sản phẩm yêu thích',
      icon: const Icon(Icons.favorite, color: Colors.red),
      onPressed: () async {
        context.push(FavoriteProductsPage.path);
      },
    );
  }

  Widget _buildMyPurchase(BuildContext context) {
    return CatalogItem(
      catalogName: 'Đơn hàng của tôi',
      catalogDescription: 'Xem tất cả đơn hàng',
      icon: const Icon(Icons.shopping_cart, color: Colors.green),
      onPressed: () {
        context.go(OrderPurchasePage.path);
      },
    );
  }

  Widget _buildRecentProduct() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const IconTextButton(
              leadingIcon: Icons.history,
              label: 'Xem gần đây',
            ),

            // delete all recent product
            TextButton(
              onPressed: () {
                sl<LocalProductDataSource>().removeAllRecentProduct().then((value) {
                  Fluttertoast.showToast(msg: 'Đã xóa lịch sử xem gần đây');
                  setState(() {
                    _recentViewedProduct = [];
                  });
                });
              },
              child: const Text('Xóa lịch sử', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
        _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ProductDetailListBuilder(
                productDetails: _recentViewedProduct,
                crossAxisCount: 1,
                itemHeight: 150,
                emptyMessage: 'Không có sản phẩm nào được xem gần đây',
                scrollDirection: Axis.horizontal,
                onTap: (index) async {
                  context.push(
                    ProductDetailPage.path,
                    extra: _recentViewedProduct[index],
                  );
                },
              ),
      ],
    );
  }

  List<Widget> _buildHeaderSliver(BuildContext context) {
    return [
      SliverAppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
        actions: [
          //# chat
          IconButton(
            onPressed: () {
              context.go(CustomerChatRoomPage.path);
            },
            icon: const Icon(Icons.chat),
          ),

          //# cart
          const CartBadge(),

          //# setting
          IconButton(
            onPressed: () => context.go('/user/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      SliverToBoxAdapter(
        child: IconButton(
          style: IconButton.styleFrom(
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
          ),
          padding: EdgeInsets.zero,
          onPressed: () => context.go(UserDetailPage.path, extra: widget.auth.userInfo),
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              //# avatar
              children: [
                const SizedBox(width: 12),
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/placeholders/a1.png'),
                ),

                const SizedBox(width: 12),

                //# full name + username + followed count
                _buildCustomerInfo(),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildCustomerInfo() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //# full name + username
          Text(
            '${widget.auth.userInfo.fullName!} (${widget.auth.userInfo.username!})',
            style: const TextStyle(fontSize: 18),
          ),

          //# followed count + loyalty point
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // followed count
                FutureBuilder(
                  future: sl<ProductRepository>().followedShopList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.fold(
                        (error) {
                          return const SizedBox();
                        },
                        (ok) => TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          ),
                          child: Text(
                            'Đang theo dõi ${ok.data!.length}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          onPressed: () {
                            context.go(FollowedShopPage.path);
                          },
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),

                const VerticalDivider(
                  color: Colors.grey,
                  thickness: 1,
                  width: 14,
                  indent: 4,
                  endIndent: 4,
                ),

                // loyalty point
                FutureBuilder(
                  future: sl<ProfileRepository>().getLoyaltyPoint(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.fold(
                        (error) {
                          return const SizedBox();
                        },
                        (ok) => TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                          ),
                          onPressed: () {
                            context.push(LoyaltyPointHistoryPage.path, extra: ok.data!.loyaltyPointId);
                          },
                          child: Text(
                            'Điểm thưởng ${ok.data!.totalPoint}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customerWidgets(BuildContext context) {
    return Wrap(
      children: [
        //# voucher
        IconTextButton(
          onPressed: () {
            context.go(MyVoucherPage.path);
          },
          padding: const EdgeInsets.all(16),
          reverseDirection: true,
          label: 'Kho Voucher',
          fontSize: 13,
          iconSize: 32,
          leadingIcon: Icons.card_giftcard,
          iconColor: Colors.orange,
          buttonStyle: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
            // backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
          ),
        ),

        //# wallet
        IconTextButton(
          onPressed: () {
            context.go(CustomerWalletHistoryPage.path);
          },
          padding: const EdgeInsets.all(16),
          reverseDirection: true,
          label: 'Ví VTV',
          fontSize: 13,
          iconSize: 32,
          leadingIcon: Icons.account_balance_wallet,
          iconColor: Colors.green,
          buttonStyle: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
            // backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
          ),
        ),
      ],
    );
  }
}

class DevPageWithString extends StatelessWidget {
  const DevPageWithString({
    super.key,
    required this.string,
  });

  final String? string;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Center(
        child: Text(string ?? 'null'),
      ),
    );
  }
}
