class Key<T> {
  const Key(this.name);

  final String name;

  @override
  String toString() => T.toString() + (name.isNotEmpty ? '($name)' : '');

  @override
  int get hashCode => T.hashCode;

  @override
  bool operator ==(Object other) => other is Key<T> && name == other.name;
}
