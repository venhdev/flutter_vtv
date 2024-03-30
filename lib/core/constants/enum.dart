// ignore_for_file: constant_identifier_names

enum Role {
  CUSTOMER,
  ADMIN,
}

enum Status {
  ACTIVE,
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
  WAITING,
  PENDING,
  SHIPPING,
  COMPLETED,
  CANCELLED,
  PROCESSING,
  CANCELED,
  DELIVERED,
}