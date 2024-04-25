//! cart-controller
const String kAPICartGetListURL = '/customer/cart/get-list'; // GET
const String kAPICartAddURL = '/customer/cart/add'; // POST
const String kAPICartUpdateURL = '/customer/cart/update'; // PUT /{cartId} --uuid
const String kAPICartDeleteURL = '/customer/cart/delete'; // DELETE /{cartId} --uuid
const String kAPICartDeleteByShopIdURL = '/customer/cart/delete-by-shop-id'; // DELETE /{shopId}

//! *location*
// province-controller
const String kAPILocationProvinceGetAllURL = '/location/province/get-all'; // GET
// district-controller
const String kAPILocationDistrictGetAllByProvinceCodeURL =
    '/location/district/get-all-by-province-code'; // GET /{provinceCode}
// ward-controller
const String kAPILocationWardGetAllByDistrictCodeURL = '/location/ward/get-all-by-district-code'; // GET /{districtCode}
const String kAPILocationWardFullAddressURL = '/location/ward/full-address'; // GET /{wardCode}

//! address-controller
const String kAPIAddressAddURL = '/customer/address/add'; // POST
const String kAPIAddressAllURL = '/customer/address/all'; // GET
const String kAPIAddressUpdateStatusURL = '/customer/address/update/status'; // PATCH
const String kAPIAddressUpdateURL = '/customer/address/update'; // PUT
// const String kAPIAddressGetURL = '/customer/address/get'; // GET

//! order-controller
// order in cart
const String kAPIOrderCreateByCartIdsURL = '/customer/order/create/by-cartIds'; // POST
const String kAPIOrderCreateUpdateWithCartURL = '/customer/order/create-update/with-cart'; // POST
// order in product variant (buy now)
const String kAPIOrderCreateByProductVariantURL = '/customer/order/create/by-product-variant'; // POST
const String kAPIOrderCreateUpdateWithProductVariantURL = '/customer/order/create-update/with-product-variant'; // POST

// place order
const String kAPIOrderAddWithProductVariantURL = '/customer/order/add/with-product-variant'; // POST --(buy now)
const String kAPIOrderAddWithCartURL = '/customer/order/add/with-cart'; // POST --(place order in cart)

// order list - manage orders
const String kAPIOrderListURL = '/customer/order/list'; // GET
const String kAPIOrderListByStatusURL = '/customer/order/list/status'; // GET /{status} --OrderStatus
const String kAPIOrderCompleteURL = '/customer/order/complete'; // PATCH /{orderId}
const String kAPIOrderDetailURL = '/customer/order/detail'; // GET /{orderId}
const String kAPIOrderCancelURL = '/customer/order/cancel'; // PATCH /{orderId}

//! voucher-controller
const String kAPIVoucherListAllURL = '/voucher/list-all'; // POST /place order
const String kAPIVoucherListOnShopURL = '/voucher/list-on-shop'; // GET /{shopId}
const String kAPIVoucherListOnSystemURL = '/voucher/list-on-system'; // GET

//! favorite-product-controller
const String kAPIFavoriteProductAddURL = '/customer/favorite-product/add'; // POST /{productId}
const String kAPIFavoriteProductListURL = '/customer/favorite-product/list'; // GET
const String kAPIFavoriteProductDeleteURL = '/customer/favorite-product/delete'; // DELETE /{favoriteProductId}
const String kAPIFavoriteProductCheckExistURL = '/customer/favorite-product/check-exist'; // GET /{productId}
const String kAPIFavoriteProductDetailURL = '/customer/favorite-product/detail'; // GET /{favoriteProductId}

//! notification-controller
const String kAPINotificationGetPageURL = '/customer/notification/get-page'; // GET
const String kAPINotificationReadURL = '/customer/notification/read'; // PUT /{notificationId}
const String kAPINotificationDeleteURL = '/customer/notification/delete'; // DELETE /{notificationId}

//! review-customer-controller
const String kAPIReviewAddURL = '/customer/review/add'; // POST
const String kAPIReviewDeleteURL = '/customer/review/delete'; // PATCH /{reviewId}
const String kAPIReviewExistByOrderItemURL = '/customer/review/exist/by-order-item'; // GET /{orderItemId}
const String kAPIReviewDetailByOrderItemURL = '/customer/review/detail/by-order-item'; // GET /{orderItemId}

//# followed-shop-controller
const String kAPIFollowedShopAddURL = '/customer/followed-shop/add'; // POST /{shopId}
const String kAPIFollowedShopListURL = '/customer/followed-shop/list'; // GET
const String kAPIFollowedShopDeleteURL = '/customer/followed-shop/delete'; // DELETE /{followedShopId}

//# loyalty-point-controller
const String kAPILoyaltyPointGetURL = '/customer/loyalty-point/get'; // GET

//# comment-customer-controller
const String kAPICommentAddURL = '/customer/comment/add'; // POST
const String kAPICommentDeleteURL = '/customer/comment/delete'; // PATCH /{commentId}