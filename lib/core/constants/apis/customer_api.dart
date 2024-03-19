part of '../api.dart';

//! customer-controller
const String kAPICustomerForgotPasswordURL = '/customer/forgot-password';
const String kAPICustomerResetPasswordURL = '/customer/reset-password';
const String kAPICustomerChangePasswordURL =
    '/customer/change-password'; // PATCH
const String kAPICustomerProfileURL = '/customer/profile'; // GET, PUT

//! cart-controller
const String kAPICartGetListURL = '/customer/cart/get-list'; // GET
const String kAPICartAddURL = '/customer/cart/add'; // POST
const String kAPICartUpdateURL =
    '/customer/cart/update'; // PUT /{'cartId'} --uuid
const String kAPICartDeleteURL =
    '/customer/cart/delete'; // DELETE {:cartId} --uuid
const String kAPICartDeleteByShopIdURL =
    '/customer/cart/delete-by-shop-id'; // DELETE {:shopId}
