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

  test('Throws error when service exists', () {
    final di = Klizma();
    di.add(() => Engine());
    expect(() => di.add(() => Engine()), throwsStateError);
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
