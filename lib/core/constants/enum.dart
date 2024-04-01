// ignore_for_file: constant_identifier_names

enum Role {
  CUSTOMER,
  ADMIN,
  VENDOR,
}

enum Status {
  ACTIVE,
  INACTIVE,
  DELETED,
  CANCEL,
  LOCKED,
}

class SortTypes {
  static const String bestSelling = 'best-selling';
  static const String newest = 'newest';
  static const String priceAsc = 'price-asc';
  static const String priceDesc = 'price-desc';
  static const String random = 'random';
}

enum VoucherTypes {
  PERCENTAGE_SHOP,
  PERCENTAGE_SYSTEM,
  MONEY_SHOP,
  MONEY_SYSTEM,
  FIXED_SHOP,
  SHIPPING,
}

enum OrderStatus {
  WAITING, // chờ xác nhận từ shop (khi hủy)
  PENDING, // chờ xác nhận từ shop (khi mới đặt)
  SHIPPING, // đang giao
  COMPLETED, // hoàn thành
  CANCELLED,
  PROCESSING,
  CANCELED, // đơn đã hủy
  DELIVERED, // đã giao ??? đang được giaoC
}
