import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  Future<void> getCurrentLocation() async {
    final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;
    final fb.User? user = auth.currentUser;
    final String userId = user!.uid;
    final SupabaseClient supabase = Supabase.instance.client;
    bool servicesEnabled;
    LocationPermission permission;

    try {
      emit(LocationLoading());

      // Check if location services are enabled
      servicesEnabled = await Geolocator.isLocationServiceEnabled();
      if (!servicesEnabled) {
        emit(const LocationError(
            "Location services are disabled. Please enable them."));
        return;
      }

      // Check location permissions
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          emit(const LocationError("Location permissions are denied."));
          return;
        }
      }

      // Get the current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
        // desiredAccuracy: LocationAccuracy.high,
      );

      try {
        final locationResponse = await supabase.from('location').upsert({
          'useruid': userId, // Associate the same user
          'lat': position.latitude,
          'long': position.longitude,
          'updated_at': DateTime.now().toIso8601String(),
        }, onConflict: 'useruid');
      } catch (e) {
        log("error saving the loction: $e");
      }

      // Emit loaded state with the current position
      final latLngPosition = LatLng(position.latitude, position.longitude);
      // emit(LocationLoaded(latLngPosition));
      final currentLat = position.latitude;
      final currentLong = position.longitude;
      // try{
      final otherUsersLoc = await supabase
          .from('location')
          .select('useruid, lat, long, Users(display_name, photo_url)')
          .neq('useruid', userId);
      log("74 $otherUsersLoc");
      // }catch (e){log("retreival of loc of others failed: $e");}
      for (final names in otherUsersLoc) {
        final name = names['Users']?['display_name'];
        final uid = names['useruid'];
        log(uid);
        log("79 $name");
      }
      final List<Map<String, dynamic>> userswithDist = [];
      for (final user in otherUsersLoc) {
        final otherLat = user['lat'];
        final otherLong = user['long'];
        // final username = user['display_name'];
        // log(username);
        final distance = Geolocator.distanceBetween(
                currentLat, currentLong, otherLat, otherLong) /
            1000;
        userswithDist.add({
          'display_name': user['Users']?['display_name'],
          'distance': distance,
          'location': LatLng(otherLat, otherLong),
          'photo_url': user['Users']?['photo_url'],
        });
      }
      log("the distance of the users from you: i$userswithDist");
      // emit(LocationLoaded(latLngPosition));
      // log("emitted location loaded");
      emit(DistanceCalculated(userswithDist));
      log("emitted distance");
      // emit(DistanceCalculated(userswithDist));
    } catch (e) {
      emit(LocationError("Failed to fetch location: ${e.toString()}"));
    }
  }
}
