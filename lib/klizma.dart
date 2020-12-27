library klizma;

import 'package:klizma/src/provider.dart';
import 'package:klizma/src/singleton.dart';

/// This is a Dependency Injection container.
/// Use it as is or inherit from [KlizmaMixin] to extend functionality.
class Klizma with KlizmaMixin {
  /// A shortcut for `get()`.
  T call<T extends Object>([String name = '']) => get<T>(name);
}

/// This is the implementation of the Dependency Injection container.
mixin KlizmaMixin {
  final _providers = <int, Map<String, Provider>>{};

  /// Adds a service [factory] of type [T] to the container.
  /// Specify [name] to have several (named) factories of the same type.
  /// By default, all services are singletons. Set [cached] to `false`
  /// to get a new instance each time the service is requested.
  ///
  /// Throws [StateError] if the service factory is already registered.
  void add<T extends Object>(T Function() factory,
      {String name = '', bool cached = true}) {
    final map = (_providers[T.hashCode] ??= <String, Provider<T>>{});
    if (map.containsKey(name)) {
      throw StateError('Service already exists');
    }
    final provider = Provider<T>(factory);
    map[name] = cached ? Singleton<T>(provider) : provider;
  }

  /// Returns the service instance for type [T].
  /// Specify [name] to get the named instance.
  ///
  /// Throws [StateError] if the service is not found.
  T get<T extends Object>([String name = '']) => _provider<T>(name).get();

  /// Returns the service instance for type [T] if it has already been instantiated.
  /// Provide [name] to get the named instance.
  ///
  /// Throws [StateError] if the service is not found.
  T? getCached<T extends Object>([String name = '']) {
    final provider = _provider<T>(name);
    if (provider is Singleton<T>) {
      return provider.getCached();
    }
  }

  Provider<T> _provider<T extends Object>(String name) =>
      (_providers[T.hashCode]?[name] ?? (throw StateError('Service not found')))
          as Provider<T>;
}
