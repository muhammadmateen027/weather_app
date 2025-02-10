import 'dart:isolate';

Future<T> runInIsolate<T>(Future<T> Function() function) async {
  return await Isolate.run(() async {
    return await function();
  });
}
