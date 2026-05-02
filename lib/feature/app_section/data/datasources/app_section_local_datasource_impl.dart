import 'package:injectable/injectable.dart';
import 'package:new_mama/core/helper/secure_storage_helper.dart';
import 'package:new_mama/feature/app_section/data/datasources/app_section_local_datasource_contract.dart';

@LazySingleton(as: AppSectionLocalDatasourceContract)
class AppSectionLocalDatasourceImpl implements AppSectionLocalDatasourceContract {

  final SecureStorageHelper _secureStorageHelper;
  AppSectionLocalDatasourceImpl(this._secureStorageHelper);
  
 static const String _refreshTokenKey = 'refresh_token';
  static const String _accessTokenKey = 'access_token';
  
  @override
  Future<void> clearTokens() async{
   await _secureStorageHelper.delete(_accessTokenKey);
  await _secureStorageHelper.delete(_refreshTokenKey);
  }
  
  @override
  Future<String?> getRefreshToken()async {
   return await _secureStorageHelper.read(_refreshTokenKey);
  }
  
}