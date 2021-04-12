import 'package:klizma/src/api.dart';

class Singleton<T> implements Factory<T> {
  Singleton(this._f);

  final FactoryFun<T> _f;

  T? value;

  @override
  T call(ServiceLocator get) => value ?? (value = _f(get));
}
