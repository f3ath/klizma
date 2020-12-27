import 'package:klizma/src/provider.dart';

class Singleton<T> implements Provider<T> {
  Singleton(this._provider);

  final Provider<T> _provider;

  T? _cached;

  @override
  T get() => _cached ??= _provider.get();

  T? getCached() => _cached;
}
