part of '../api.dart';

//! customer-controller
const String kAPICustomerForgotPasswordURL = '/customer/forgot-password';
const String kAPICustomerResetPasswordURL = '/customer/reset-password';
const String kAPICustomerChangePasswordURL = '/customer/change-password'; // PATCH
const String kAPICustomerProfileURL = '/customer/profile'; // GET, PUT

//! cart-controller
const String kAPICartGetListURL = '/customer/cart/get-list'; // GET
const String kAPICartAddURL = '/customer/cart/add'; // POST
const String kAPICartUpdateURL = '/customer/cart/update'; // PUT /{'cartId'} --uuid
const String kAPICartDeleteURL = '/customer/cart/delete'; // DELETE {:cartId} --uuid
const String kAPICartDeleteByShopIdURL = '/customer/cart/delete-by-shop-id'; // DELETE {:shopId}

//! *location*
// province
const String kAPILocationProvinceGetAllURL = '/location/province/get-all'; // GET
// district
const String kAPILocationDistrictGetAllByProvinceCodeURL =
    '/location/district/get-all-by-province-code'; // GET /{provinceCode}
// ward
const String kAPILocationWardGetAllByDistrictCodeURL = '/location/ward/get-all-by-district-code'; // GET /{districtCode}
const String kAPILocationWardFullAddressURL = '/location/ward/full-address'; // GET /{wardCode}

//! address-controller
const String kAPIAddressAddURL = '/customer/address/add'; // POST
const String kAPIAddressAllURL = '/customer/address/all'; // GET
const String kAPIAddressUpdateStatusURL = '/customer/address/update/status'; // PATCH

//! order-controller
const String kAPIOrderCreateByCartIdsURL = '/customer/order/create/by-cartIds'; // POST
const String kAPIOrderCreateUpdateWithCartURL = '/customer/order/create-update/with-cart'; // POST
const String kAPIOrderCreateByProductVariantURL = '/customer/order/create/by-product-variant'; // POST

const String kAPIOrderListURL = '/customer/order/list'; // GET
const String kAPIOrderListByStatusURL = '/customer/order/list/status'; // GET /{status} --OrderStatus

const String kAPIOrderAddWithCartURL = '/customer/order/add/with-cart'; // POST --place order

//! voucher-controller
const String kAPIVoucherListAllURL = '/voucher/list-all'; // POST /place order
const String kAPIVoucherListOnShopURL = '/voucher/list-on-shop'; // GET /{shopId}
const String kAPIVoucherListOnSystemURL = '/voucher/list-on-system'; // GET

//! favorite-product-controller
const String kAPIFavoriteProductAddURL = '/customer/favorite-product/add'; // POST /{productId}
const String kAPIFavoriteProductListURL = '/customer/favorite-product/list'; // GET
const String kAPIFavoriteProductDeleteURL = '/customer/favorite-product/delete'; // DELETE /{favoriteProductId}



// const String kAPI_URL = ''; // method --description