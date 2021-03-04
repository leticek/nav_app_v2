import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:navigation_app/services/auth.dart';

final authServiceProvider = ChangeNotifierProvider<AuthService>((ref) => AuthService.instance());