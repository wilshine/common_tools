import 'package:permission_handler/permission_handler.dart';
import 'permission_manager.dart';

class PermissionHandlerManager extends PermissionManager {


  @override
  Future<bool> requestPermission(int permissionCode) async {
    return PermissionCode(permissionCode).permission.request().isGranted;
  }

  @override
  Future<bool> isGranted(int permissionCode) async {
    return PermissionCode(permissionCode).permission.isGranted;
  }

  @override
  Future<bool> openSettings() {
    return openAppSettings();
  }
}
