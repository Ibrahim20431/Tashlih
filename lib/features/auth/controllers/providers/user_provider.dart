import 'dart:convert' show jsonDecode;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/key_classes.dart';
import '../../../../core/providers/shared_prefs_provider.dart';
import '../../data/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) {
  final prefs = ref.read(sharedPrefsProvider);
  final userString = prefs.getString(StorageKeys.user);
  if (userString != null) return UserModel.fromMap(jsonDecode(userString));
  return null;
});
