part of '../api.dart';

//# category-controller
const String kAPIAllCategoryURL = '/category/all-parent'; // GET

//# product-suggestion-controller
const String kAPISuggestionProductURL = '/product-suggestion/get-page/randomly'; // GET

//# search-product-controller
const String kAPISearchProductSortURL = '/search/product/sort'; // GET --only keyword
const String kAPIGetSearchProductPriceRangeSortURL = '/search/product/price-range/sort'; // GET

//# product-filter-controller
const String kAPIProductFilterURL = '/product-filter'; // GET /{filter}
const String kAPIProductFilterPriceRangeURL = '/product-filter/price-range'; // GET /{filter}

//# product-controller
const String kAPIProductDetailURL = '/product/detail'; // GET /{productId}

//# product-page-controller
const String kAPIProductPageCategoryURL = '/product/page/category'; // GET /{categoryId}