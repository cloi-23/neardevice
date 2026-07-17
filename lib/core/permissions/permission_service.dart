import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  PermissionService._();

  static Future<bool> requestNearbyPermissions() async {
    final location = await Permission.location.request();

    return location.isGranted;
  }
}
