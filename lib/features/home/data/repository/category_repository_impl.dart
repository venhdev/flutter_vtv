import '../../../../core/constants/typedef.dart';
import '../../../../core/network/response_handler.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repository/category_repository.dart';
import '../data_sources/category_data_source.dart';

class CategoryRepositoryImpl extends CategoryRepository {
  CategoryRepositoryImpl(this._categoryDataSource);

  final CategoryDataSource _categoryDataSource;
  @override
  FRespData<List<CategoryEntity>> getAllParentCategories() async {
    // try {
    //   final result = await _categoryDataSource.getAllParentCategories();
    //   return Right(result);
    // } on ClientException catch (e) {
    //   return Left(ClientError(code: e.code, message: e.message));
    // } on ServerException catch (e) {
    //   return Left(ServerError(code: e.code, message: e.message));
    // } catch (e) {
    //   return Left(UnexpectedError(message: e.toString()));
    // }

    return await handleDataResponseFromDataSource(
      dataExecute: () async => _categoryDataSource.getAllParentCategories(),
    );
  }
}
