/// A string representation of a named service
class Service {
  const Service(this.type, this.name);

  final Type type;

  final String name;

  @override
  String toString() => type.toString() + (name.isNotEmpty ? '($name)' : '');
}
