import 'package:flutter_riverpod/flutter_riverpod.dart' show StateProvider;

import '../models/response_model.dart';

final responseProvider = StateProvider<ResponseModel>(
  (_) => const ResponseModel(
    success: false,
    statusCode: 0,
    message: '',
    data: null,
    errors: {},
  ),
);
