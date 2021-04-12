import 'package:klizma/src/api.dart';
import 'package:klizma/src/key.dart';
import 'package:klizma/src/lambda.dart';
import 'package:klizma/src/singleton.dart';

/// This is a Dependency Injection container.
/// Use it as is or inherit from [ContainerMixin] to extend functionality.
class Container with ContainerMixin {}

/// This is a Dependency Injection container implementation.
mixin ContainerMixin {
  /// Registers a service [factory] of type [T] in the container.
  /// Specify [name] to have several (named) factories of the same type.
  /// By default, all services are singletons. Set [cached] to `false`
  /// to get a new instance each time the service is requested.
  void provide<T extends Object>(FactoryFun<T> factory,
      {String name = '', bool cached = true}) {
    _map[Key<T>(name)] = cached ? Singleton<T>(factory) : Lambda<T>(factory);
  }

  /// Returns true if the service is registered in the container
  bool has<T>([String name = '']) => _map.containsKey(Key<T>(name));

  /// Returns the service instance for type [T].
  /// Specify [name] to get the named instance.
  ///
  /// Throws [StateError] if the service is not found.
  T get<T>([String name = '']) => _factory<T>(name)(get);

  /// Returns the service instance for type [T] if it has already been instantiated.
  /// Provide [name] to get the named instance.
  ///
  /// Throws [StateError] if the service is not found.
  T? getCached<T extends Object>([String name = '']) {
    final factory = _factory<T>(name);
    if (factory is Singleton<T>) return factory.value;
  }

  final _map = <Key, Factory>{};

  Factory<T> _factory<T>(String name) {
    final key = Key<T>(name);
    return (_map[key] ?? (throw StateError('Service not found: $key')))
        as Factory<T>;
  }
}
