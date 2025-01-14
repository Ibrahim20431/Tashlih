import 'package:flutter/foundation.dart' show mustCallSuper;
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;

import '../providers/request_provider.dart';
import 'request_state.dart';

mixin class StateRequestMixin {
  late final Ref _ref;

  @mustCallSuper
  void initializeRef(Ref ref) => _ref = ref;

  @mustCallSuper
  void loading() => _setRequestState(const LoadingState());

  @mustCallSuper
  void success([String? message]) =>
      _setRequestState(SuccessState(message: message));

  @mustCallSuper
  void error(Object error, [String? message]) =>
      _setRequestState(ErrorState(error, message: message));

  void _setRequestState(RequestState state) =>
      _ref.read(requestProvider.notifier).state = state;
}
