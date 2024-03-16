part of '../api.dart';

//! category-controller
const String kAPIAllCategoryURL = '/category/all-parent'; // GET

//! product-suggestion-controller
const String kAPISuggestionProductURL =
    '/product-suggestion/get-page/randomly'; // GET

//! search-product-controller
// only keyword sort
const String kAPISearchProductSortURL = '/search/product/sort'; // GET
// keyword + price range + sort type
const String kAPIGetSearchProductPriceRangeSortURL =
    '/search/product/price-range/sort'; // GET

//! product-filter-controller
//HOME --GET /api/product-filter/{filter} -> best seller, new, price asc, price desc
const String kAPIProductFilterURL = '/product-filter'; // GET /{filter}
// when user have range
const String kAPIProductFilterPriceRangeURL =
    '/product-filter/price-range'; // GET /{filter}
