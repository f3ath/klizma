class Lambda<T> {
  const Lambda(this._lambda);

  final T Function() _lambda;

  T get() => _lambda();
}
