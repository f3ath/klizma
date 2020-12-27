class Provider<T> {
  const Provider(this._lambda);

  final T Function() _lambda;

  T get() => _lambda();
}
