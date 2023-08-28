import 'dart:async';
import 'dart:developer' as dev;

import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final locationProvider = StateNotifierProvider<LocationProvider, AsyncValue<Position?>>(
  (ref) {
    return LocationProvider(ref);
  },
);

class LocationProvider extends StateNotifier<AsyncValue<Position?>> {
  LocationProvider(this.ref) : super(const AsyncValue.loading()) {
    getLocation();
  }
  final Ref ref;

  Future<AsyncValue<Position?>> getLocation() async {
    try {
      if (state is AsyncData) {
        return state;
      }
      state = const AsyncValue.loading();
      final permission = await Geolocator.checkPermission();
      permission.log('getLocation->permission');
      final isLocationGranted = [
        LocationPermission.always,
        LocationPermission.whileInUse,
      ].contains(permission);
      //
      late Position position;
      if (isLocationGranted) {
        position = await Geolocator.getCurrentPosition().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            state = AsyncValue.error('unabletogetlocation', StackTrace.current);
            return Future.error('unabletogetlocation');
          },
        );
        state = AsyncValue.data(position);
      } else {
        final result = await _checkLocationPermission().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            state = AsyncValue.error('unabletogetlocation', StackTrace.current);
            return Future.error('unabletogetlocation');
          },
        );
        if (!result) {
          state = AsyncValue.error('notgranted', StackTrace.current);
        } else {
          position = await Geolocator.getCurrentPosition();
          state = AsyncValue.data(position);
        }
      }

      return state;
    } catch (e, s) {
      state = AsyncValue.error(e, s);
      return state;
    }
  }

  Future<bool> _checkLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('permission');
    }

    final locationPermissionStatus = await Geolocator.requestPermission();

    locationPermissionStatus.log('getLocation->locationPermissionStatus');
    if (locationPermissionStatus == LocationPermission.deniedForever) {
      return Future.error('notgranted');
    }
    if (locationPermissionStatus == LocationPermission.denied) {
      return await _checkLocationPermission();
    }

    return true;
  }
}

final locationFutureProvider = FutureProvider.autoDispose<Position>((ref) async {
  final isLocationGranted = await Permission.location.isGranted;
  late Position position;

  if (isLocationGranted) {
    position = await Geolocator.getCurrentPosition().timeout(
      const Duration(seconds: 10),
      onTimeout: () => Future.error('unabletogetlocation'),
    );
  } else {
    throw Exception('Location permission is not granted');
  }
  return position;
});

extension on Object {
  void log([String? name]) {
    dev.log(toString(), name: name ?? '');
  }
}
