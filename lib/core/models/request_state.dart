sealed class RequestState<T> {
  const RequestState();

  const factory RequestState.init() = InitState<T>;

  const factory RequestState.loading() = LoadingState<T>;

  factory RequestState.success({
    T? data,
    String? message,
    int statusCode = 0,
  }) =>
      SuccessState<T>(
        data: data,
        message: message,
        statusCode: statusCode,
      );

  factory RequestState.error(
    Object error, {
    T? data,
    String? message,
    int statusCode = 0,
  }) =>
      ErrorState<T>(
        error,
        data: data,
        message: message,
        statusCode: statusCode,
      );

  bool get isInit;

  bool get isLoading;

  int get statusCode;

  bool get hasData;

  T? get data;

  T get requiredData;

  bool get hasError;

  Object? get error;

  String? get message;

  bool get hasMessage;
}

final class InitState<T> implements RequestState<T> {
  const InitState();

  @override
  bool get isInit => true;

  @override
  bool get isLoading => false;

  @override
  int get statusCode => 0;

  @override
  bool get hasData => false;

  @override
  T? get data => null;

  @override
  T get requiredData =>
      throw UnsupportedError('requiredData unsupported for InitState');

  @override
  bool get hasError => false;

  @override
  Object? get error => null;

  @override
  String? get message => null;

  @override
  bool get hasMessage => false;
}

final class LoadingState<T> implements RequestState<T> {
  const LoadingState();

  @override
  bool get isInit => false;

  @override
  bool get isLoading => true;

  @override
  int get statusCode => 0;

  @override
  bool get hasData => false;

  @override
  T? get data => null;

  @override
  T get requiredData =>
      throw UnsupportedError('requiredData unsupported for LoadingState');

  @override
  bool get hasError => false;

  @override
  Object? get error => null;

  @override
  String? get message => null;

  @override
  bool get hasMessage => false;
}

final class SuccessState<T> implements RequestState<T> {
  const SuccessState({this.data, this.message, this.statusCode = 0});

  @override
  bool get isInit => false;

  @override
  bool get isLoading => false;

  @override
  final int statusCode;

  @override
  bool get hasData => true;

  @override
  final T? data;

  @override
  T get requiredData => data!;

  @override
  bool get hasError => false;

  @override
  Object? get error => null;

  @override
  final String? message;

  @override
  bool get hasMessage => message != null;
}

final class ErrorState<T> implements RequestState<T> {
  const ErrorState(this.error, {this.data, this.message, this.statusCode = 0});

  @override
  bool get isInit => false;

  @override
  bool get isLoading => false;

  @override
  final int statusCode;

  @override
  bool get hasData => false;

  @override
  final T? data;

  @override
  T get requiredData => data!;

  @override
  bool get hasError => true;

  @override
  final Object error;

  @override
  final String? message;

  @override
  bool get hasMessage => message != null;
}
