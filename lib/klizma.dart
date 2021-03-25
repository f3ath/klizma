library klizma;

import 'package:klizma/src/key.dart';
import 'package:klizma/src/lambda.dart';
import 'package:klizma/src/singleton.dart';

/// This is a Dependency Injection container.
/// Use it as is or inherit from [KlizmaMixin] to extend functionality.
class Klizma with KlizmaMixin {
  /// A shortcut for `get()`.
  T call<T extends Object>([String name = '']) => get<T>(name);
}

/// This is the implementation of the Dependency Injection container.
mixin KlizmaMixin {
  /// Adds a service [factory] of type [T] to the container.
  /// Specify [name] to have several (named) factories of the same type.
  /// By default, all services are singletons. Set [cached] to `false`
  /// to get a new instance each time the service is requested.
  ///
  /// Throws [StateError] if the service factory is already registered.
  void add<T extends Object>(T Function() factory,
      {String name = '', bool cached = true}) {
    final key = Key<T>(name);
    if (_has(key)) throw StateError('Service already registered: $key');
    _set(key, factory, cached);
  }

  /// Returns `true` if the service is registered in the container.
  bool has<T extends Object>([String name = '']) => _has(Key<T>(name));

  /// Replaces an existing service [factory] of type [T] to the container.
  /// Specify [name] to have several (named) factories of the same type.
  /// By default, all services are singletons. Set [cached] to `false`
  /// to get a new instance each time the service is requested.
  ///
  /// Throws [StateError] if the service factory has not been previously registered.
  void replace<T extends Object>(T Function() factory,
      {String name = '', bool cached = true}) {
    final key = Key<T>(name);
    if (!_has(key)) throw StateError('Service is not registered: $key');
    _set(key, factory, cached);
  }

  /// Adds or replaces a service [factory] of type [T] in the container.
  /// Specify [name] to have several (named) factories of the same type.
  /// By default, all services are singletons. Set [cached] to `false`
  /// to get a new instance each time the service is requested.
  ///
  /// Returns true if the service existed and has been replaced, false otherwise.
  bool set<T extends Object>(T Function() factory,
      {String name = '', bool cached = true}) {
    final existed = has<T>(name);
    _set(Key<T>(name), factory, cached);
    return existed;
  }

  /// Returns the service instance for type [T].
  /// Specify [name] to get the named instance.
  ///
  /// Throws [StateError] if the service is not found.
  T get<T extends Object>([String name = '']) => _factory<T>(name).get();

  /// Returns the service instance for type [T] if it has already been instantiated.
  /// Provide [name] to get the named instance.
  ///
  /// Throws [StateError] if the service is not found.
  T? getCached<T extends Object>([String name = '']) {
    final factory = _factory<T>(name);
    if (factory is Singleton<T>) return factory.getCached();
  }

  final _factories = <Key, Lambda>{};

  /// Adds or replaces a service [factory] of type [T] in the container.
  /// By default, all services are singletons. Set [cached] to `false`
  /// to get a new instance each time the service is requested.
  void _set<T extends Object>(Key<T> key, T Function() factory, bool cached) {
    final lambda = Lambda<T>(factory);
    _factories[key] = cached ? Singleton<T>(lambda) : lambda;
  }

  /// Returns `true` if the service is registered in the container.
  bool _has(Key key) => _factories.containsKey(key);

  Lambda<T> _factory<T extends Object>(String name) {
    final key = Key<T>(name);
    final lambda = _factories[key];
    if (lambda == null) throw StateError('Service not found: $key');
    return lambda as Lambda<T>;
  }
}
