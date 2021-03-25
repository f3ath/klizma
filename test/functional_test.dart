import 'package:klizma/klizma.dart';
import 'package:test/test.dart';

import 'other_engine.dart' as other;

void main() {
  test('Can produce a service using singleton', () {
    final di = Klizma();
    di.add(() => Engine());
    final engine1 = di.get<Engine>();
    final engine2 = di.get<Engine>();
    expect(engine1, isA<Engine>());
    expect(engine2, isA<Engine>());
    expect(engine1, same(engine2));
  });

  test('Can produce a named service using singleton', () {
    final di = Klizma();
    di.add(() => Engine());
    di.add(() => Engine('Diesel'), name: 'diesel');
    expect(di<Engine>(), isNot(same(di<Engine>('diesel'))));
    expect(di<Engine>('diesel'), same(di<Engine>('diesel')));
    expect(di<Engine>(), same(di<Engine>()));
  });

  test('Can produce a service using factory', () {
    final di = Klizma();
    di.add(() => Engine(), cached: false);
    final engine1 = di<Engine>();
    final engine2 = di<Engine>();
    expect(engine1, isA<Engine>());
    expect(engine2, isA<Engine>());
    expect(engine1, isNot(same(engine2)));
  });

  test('Can produce a named service using factory', () {
    final di = Klizma();
    di.add(() => Engine(), cached: false);
    di.add(() => Engine('diesel'), cached: false, name: 'diesel');
    expect(di<Engine>(), isNot(same(di<Engine>())));
    expect(di<Engine>().name, equals(di<Engine>().name));
    expect(di<Engine>('diesel'), isNot(same(di<Engine>('diesel'))));
    expect(di<Engine>('diesel').name, equals(di<Engine>('diesel').name));
    expect(di<Engine>().name, isNot(equals(di<Engine>('diesel').name)));
  });

  test('Throws error when service not found', () {
    final di = Klizma();
    di.add(() => Engine());
    expect(() => di<String>(), throwsStateError);
    expect(() => di<Engine>('foo'), throwsStateError);
  });

  test('add() throws error when service exists', () {
    final di = Klizma();
    di.add(() => Engine());
    expect(() => di.add(() => Engine()), throwsStateError);
  });

  test('replace() throws error when service does not exist', () {
    final di = Klizma();
    expect(() => di.replace(() => Engine()), throwsStateError);
  });

  test('replace() replaces existing service', () {
    final di = Klizma();
    di.add<String>(() => 'foo');
    di.add<String>(() => 'foo.special', name: 'special');
    di.add<String>(() => 'foo.uncached', name: 'uncached', cached: false);

    expect(di.get<String>(), 'foo');
    expect(di.get<String>('special'), 'foo.special');
    expect(di.get<String>('uncached'), 'foo.uncached');

    di.replace<String>(() => 'bar');

    expect(di.get<String>(), 'bar');
    expect(di.get<String>('special'), 'foo.special');
    expect(di.get<String>('uncached'), 'foo.uncached');

    di.replace<String>(() => 'bar.special', name: 'special');

    expect(di.get<String>(), 'bar');
    expect(di.get<String>('special'), 'bar.special');
    expect(di.get<String>('uncached'), 'foo.uncached');

    di.replace<String>(() => 'bar.uncached', name: 'uncached', cached: false);

    expect(di.get<String>(), 'bar');
    expect(di.get<String>('special'), 'bar.special');
    expect(di.get<String>('uncached'), 'bar.uncached');
  });

  test('set() returns true/false', () {
    final di = Klizma();
    expect(di.set(() => Engine()), isFalse);
    expect(di.set(() => Engine()), isTrue);
    expect(di.set(() => Engine(), name: 'test'), isFalse);
    expect(di.set(() => Engine(), name: 'test'), isTrue);
  });

  test('Class name collision safety', () {
    final di = Klizma();
    di.add(() => Engine());
    di.add(() => other.Engine());
    expect(di<Engine>(), isA<Engine>());
    expect(di<other.Engine>(), isA<other.Engine>());
    expect(di<Engine>(), isNot(same(di<other.Engine>())));
  });

  test('Get cached', () {
    final di = Klizma();
    di.add(() => Engine());
    expect(di.getCached<Engine>(), isNull);
    di<Engine>();
    expect(di.getCached<Engine>(), isNotNull);
  });
}

class Engine {
  Engine([this.name = 'V4']);

  final String name;
}
