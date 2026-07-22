import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';

class LocationDatabaseService {
  LocationDatabaseService()
      : _database = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              'https://location-sharing-3ff95-default-rtdb.asia-southeast1.firebasedatabase.app',
        );

  final FirebaseDatabase _database;

  Future<void> saveLocation({
    required String deviceId,
    required String deviceName,
    required Position position,
  }) {
    return _database.ref('locations/$deviceId').update({
      'deviceName': deviceName,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'accuracy': position.accuracy,
      'lastUpdated': ServerValue.timestamp,
    });
  }

  Stream<DatabaseEvent> watchLocations() {
    return _database.ref('locations').onValue;
  }
}
