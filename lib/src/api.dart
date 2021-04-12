/// Service locator function returns a service by type and [name].
typedef ServiceLocator = V Function<V>([String name]);

/// Factory function creates a service using dependencies from [ServiceLocator].
typedef FactoryFun<T> = T Function(ServiceLocator get);

/// Factory object
abstract class Factory<T> {
  T call(ServiceLocator get);
}
