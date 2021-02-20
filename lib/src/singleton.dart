import 'package:klizma/src/lambda.dart';

class Singleton<T> implements Lambda<T> {
  Singleton(this._provider);

  final Lambda<T> _provider;

  T? _cached;

  @override
  T get() => _cached ??= _provider.get();

  T? getCached() => _cached;
}
