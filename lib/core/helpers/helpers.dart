import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../features/auth/presentation/bloc/auth_cubit.dart';
import '../constants/enum.dart';

DateTime getToday() {
  DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

/// use to get {day month year} from DateTime
///
/// => yyyy-MM-dd : 00:00:00.000
DateTime getDate(DateTime dateTime) {
  return DateTime(dateTime.year, dateTime.month, dateTime.day);
}

/// use to check if the user is logged in or not
bool isLogin(BuildContext context) {
  return context.read<AuthCubit>().state.status == AuthStatus.authenticated;
}

bool isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

String formatCurrency(int value, {bool showUnit = true, String? unit = 'đ'}) {
  var f = NumberFormat.decimalPattern();
  if (!showUnit) return f.format(value);
  return '${f.format(value)}$unit';
  // return value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
}

String formatPaymentMethod(String method) {
  switch (method) {
    case 'COD': // Cash on delivery
      return 'Thanh toán khi nhận hàng';
    case 'momo':
      return 'MoMo';
    case 'zalopay':
      return 'ZaloPay';
    case 'visa':
      return 'Visa';
    case 'mastercard':
      return 'MasterCard';
    default:
      return method;
  }
}

String formatVoucherType({required String type, required int discount}) {
  if (type == VoucherTypes.PERCENTAGE_SYSTEM.name) {
    return 'Giảm $discount%';
  } else if (type == VoucherTypes.PERCENTAGE_SHOP.name) {
    return 'Giảm $discount%';
  } else if (type == VoucherTypes.MONEY_SHOP.name) {
    return 'Giảm ${formatCurrency(discount)}';
  } else if (type == VoucherTypes.MONEY_SYSTEM.name) {
    return 'Giảm ${formatCurrency(discount)}';
  } else if (type == VoucherTypes.FIXED_SHOP.name) {
    return 'Giảm ${formatCurrency(discount)}';
  } else if (type == VoucherTypes.SHIPPING.name) {
    return 'Miễn phí vận chuyển đến ${formatCurrency(discount)}';
  }
  return '';
}

String formatOrderStatus(OrderStatus status) {
  switch (status) {
    case OrderStatus.WAITING:
      return 'Draft'; // when create order (not place order yet)
    case OrderStatus.PENDING:
      return 'Chờ xác nhận';
    case OrderStatus.SHIPPING:
      return 'Đang giao';
    case OrderStatus.COMPLETED:
      return 'Hoàn thành';
    case OrderStatus.DELIVERED:
      return 'Đã giao';
    case OrderStatus.CANCELLED:
      return 'Đã hủy';
    // Vendor Only
    case OrderStatus.PROCESSING:
      return 'Đang xử lý';

    //! Unknown status
    default:
      return status.name;
  }
}
