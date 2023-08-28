import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location_provider_widget/src/widgets/primary_button.dart';

import 'location_provider.dart';
import 'widgets/state_info_widget.dart';

class LocationProviderWidget extends HookConsumerWidget {
  final Widget Function(Position) child;
  final Widget? permissionNotGranted;
  final Widget Function()? loading;
  final Widget Function(Object e)? error;
  const LocationProviderWidget({
    Key? key,
    required this.child,
    this.permissionNotGranted,
    this.loading,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(locationProvider).when(
          data: (location) {
            if (location == null) {
              return StateInfoWidget(
                title: 'Please Enable Location',
                description: 'Your location services is off, Please enable location.',
                buttonText: 'Turn on location',
                onTap: () async {
                  await Geolocator.openLocationSettings();
                  ref.invalidate(locationProvider);
                },
              );
            }

            return HookBuilder(
              builder: (context) {
                return child(location);
              },
            );
          },
          loading: loading ?? () => const CircularProgressIndicator(),
          error: (e, s) {
            if (e is geolocator.LocationServiceDisabledException) {
              return StateInfoWidget(
                title: 'Please Enable Location',
                description: 'Your location services is off, Please enable location.',
                buttonText: 'Turn on location',
                onTap: () async {
                  await Geolocator.openLocationSettings();
                  ref.invalidate(locationProvider);
                },
              );
            }
            if (e is geolocator.PermissionDeniedException) {
              return StateInfoWidget(
                title: 'Permission Location is Denied',
                description: 'Please Enable the location permission from app settings.',
                buttonText: 'Open App Setting',
                onTap: () async {
                  await geolocator.Geolocator.openAppSettings();
                  ref.invalidate(locationProvider);
                },
              );
            }
            if (e == 'permission') {
              return StateInfoWidget(
                title: 'Please Enable Location',
                description: 'Your location services is off, Please enable location.',
                buttonText: 'Turn on location',
                onTap: () async {
                  await Geolocator.openLocationSettings();
                  ref.invalidate(locationProvider);
                },
              );
            } else if (e == 'notgranted') {
              return permissionNotGranted ??
                  StateInfoWidget(
                    title: 'Fine location permission not granted.',
                    description:
                        'Location services are required for Bluetooth, please enable the location permission.',
                    buttonText: 'Turn on',
                    onTap: () async {
                      await Geolocator.requestPermission();
                      ref.invalidate(locationProvider);
                    },
                  );
            } else if (e == 'unabletogetlocation') {
              return StateInfoWidget(
                title: 'Unable to get location',
                description: 'Try restarting the phone or connect to internet and try again.',
                buttonText: 'Refresh',
                onTap: () async {
                  // await Geolocator.openLocationSettings();
                  ref.invalidate(locationProvider);
                },
              );
            }

            return error?.call(e) ??
                PrimaryButton(
                  text: e.toString(),
                  onTap: () {
                    ref.invalidate(locationProvider);
                  },
                );
          },
        );
  }
}
