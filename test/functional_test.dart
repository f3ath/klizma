import 'package:klizma/klizma.dart';
import 'package:test/test.dart';

import 'other_engine.dart' as other;

void main() {
  test('Can produce a service using singleton', () {
    final di = Container();
    di.provide((_) => Engine());
    final engine1 = di.get<Engine>();
    final engine2 = di.get<Engine>();
    expect(engine1, isA<Engine>());
    expect(engine2, isA<Engine>());
    expect(engine1, same(engine2));
  });

  test('Can produce a named service using singleton', () {
    final di = Container();
    di.provide((_) => Engine());
    di.provide((_) => Engine('Diesel'), name: 'diesel');
    expect(di.get<Engine>(), isNot(same(di.get<Engine>('diesel'))));
    expect(di.get<Engine>('diesel'), same(di.get<Engine>('diesel')));
    expect(di.get<Engine>(), same(di.get<Engine>()));
  });

  test('Can produce a service using factory', () {
    final di = Container();
    di.provide((_) => Engine(), cached: false);
    final engine1 = di.get<Engine>();
    final engine2 = di.get<Engine>();
    expect(engine1, isA<Engine>());
    expect(engine2, isA<Engine>());
    expect(engine1, isNot(same(engine2)));
  });

  test('Can produce a named service using factory', () {
    final di = Container();
    di.provide((_) => Engine(), cached: false);
    di.provide((_) => Engine('diesel'), cached: false, name: 'diesel');
    expect(di.get<Engine>(), isNot(same(di.get<Engine>())));
    expect(di.get<Engine>().name, equals(di.get<Engine>().name));
    expect(di.get<Engine>('diesel'), isNot(same(di.get<Engine>('diesel'))));
    expect(
        di.get<Engine>('diesel').name, equals(di.get<Engine>('diesel').name));
    expect(di.get<Engine>().name, isNot(equals(di.get<Engine>('diesel').name)));
  });

  test('Throws error when service not found', () {
    final di = Container();
    di.provide((_) => Engine());
    expect(di.has<Engine>(), isTrue);
    expect(di.has<String>(), isFalse);
    expect(di.has<Engine>('foo'), isFalse);
    expect(() => di.get<String>(), throwsStateError);
    expect(() => di.get<Engine>('foo'), throwsStateError);
  });

  test('register() replaces existing service', () {
    final di = Container();
    di.provide<String>((_) => 'foo');
    di.provide<String>((_) => 'foo.special', name: 'special');
    di.provide<String>((_) => 'foo.uncached', name: 'uncached', cached: false);

    expect(di.get<String>(), 'foo');
    expect(di.get<String>('special'), 'foo.special');
    expect(di.get<String>('uncached'), 'foo.uncached');

    di.provide<String>((_) => 'bar');

    expect(di.get<String>(), 'bar');
    expect(di.get<String>('special'), 'foo.special');
    expect(di.get<String>('uncached'), 'foo.uncached');

    di.provide<String>((_) => 'bar.special', name: 'special');

    expect(di.get<String>(), 'bar');
    expect(di.get<String>('special'), 'bar.special');
    expect(di.get<String>('uncached'), 'foo.uncached');

    di.provide<String>((_) => 'bar.uncached', name: 'uncached', cached: false);

    expect(di.get<String>(), 'bar');
    expect(di.get<String>('special'), 'bar.special');
    expect(di.get<String>('uncached'), 'bar.uncached');
  });

  test('Class name collision safety', () {
    final di = Container();
    di.provide((_) => Engine());
    di.provide((_) => other.Engine());
    expect(di.get<Engine>(), isA<Engine>());
    expect(di.get<other.Engine>(), isA<other.Engine>());
    expect(di.get<Engine>(), isNot(same(di.get<other.Engine>())));
  });

  test('Get cached', () {
    final di = Container();
    di.provide((_) => Engine());
    expect(di.getCached<Engine>(), isNull);
    di.get<Engine>();
    expect(di.getCached<Engine>(), isNotNull);
  });

  test('Can use closures', () async {
    square(int a) => a * a;
    str(int a) => a.toString();

    Future<int?> fun(Engine _) async => 42;

    final di = Container();
    di.provide((_) => square);
    di.provide((_) => str);
    di.provide((_) => fun);
    di.provide((_) => (_) async => 'yo');

    expect(di.get<int Function(int _)>()(3), 9);
    expect(di.get<String Function(int _)>()(3), '3');
    expect(await di.get<Future<int?> Function(Engine _)>()(Engine()), 42);
    expect(await di.get<Future<String> Function(dynamic _)>()(Engine()), 'yo');
  });
}

class Engine {
  Engine([this.name = 'V4']);

  final String name;
}
