import 'package:klizma/src/api.dart';

class Lambda<T> implements Factory<T> {
  const Lambda(this._f);

  final FactoryFun<T> _f;

  @override
  T call(ServiceLocator get) => _f(get);
}
