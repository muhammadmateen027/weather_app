part of 'weather_cubit.dart';

enum DataState { initial, loading, success, failure }

extension DataStateX on DataState {
  bool get isInitial => this == DataState.initial;

  bool get isLoading => this == DataState.loading;

  bool get isSuccess => this == DataState.success;

  bool get isFailure => this == DataState.failure;
}
