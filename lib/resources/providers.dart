import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/resources/models/new_route.dart';
import 'package:navigation_app/services/auth.dart';
import 'package:navigation_app/services/ors_service.dart';

final authServiceProvider =
    ChangeNotifierProvider<AuthService>((ref) => AuthService.instance());
final openRouteServiceProvider = ChangeNotifierProvider<OpenRouteService>(
    (ref) => OpenRouteService.instance());
final newRouteProvider = ChangeNotifierProvider<NewRoute>((ref) => NewRoute());
