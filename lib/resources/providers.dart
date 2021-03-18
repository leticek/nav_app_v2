import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/services/auth.dart';
import 'package:navigation_app/services/firestore.dart';
import 'package:navigation_app/services/open_route_service.dart';
import 'package:navigation_app/services/watch_connection.dart';

final authServiceProvider = ChangeNotifierProvider<AuthService>(
    (ref) => AuthService.instance(ref.read));
final openRouteServiceProvider = ChangeNotifierProvider<OpenRouteService>(
    (ref) => OpenRouteService.instance());
final firestoreProvider =
    Provider<FirestoreService>((ref) => FirestoreService.instance());
final watchConnectionProvider =
    ChangeNotifierProvider<WatchService>((ref) => WatchService());
