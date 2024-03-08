part of '../api.dart';

//! category-controller
const String kAPIGetAllCategoryURL = '/category/all-parent'; // GET

//! product-suggestion-controller
const String kAPIGetSuggestionProductURL = '/product-suggestion/get-page/randomly'; // GET

//! search-product-controller
// only keyword sort
const String kAPIGetSearchProductURL = '/search/product/sort'; // GET
// keyword + price range + sort type
const String kAPIGetSearchProductPriceRangeSortURL = '/search/product/price-range/sort'; // GET

//! product-filter-controller
//HOME --GET /api/product-filter/{filter} -> best seller, new, price asc, price desc
// const String kAPIGetProductFilterURL = '/product-filter'; // GET
// when user have range
const String kAPIGetProductFilterPriceRangeURL = '/product-filter/price-range'; // GET 
