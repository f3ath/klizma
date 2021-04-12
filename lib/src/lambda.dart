import 'package:klizma/src/factory_function.dart';

class Factory<T> {
  const Factory(this.get);

  final FactoryFun<T> get;
}
