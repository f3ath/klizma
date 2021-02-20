import 'package:klizma/klizma.dart';

void main() {
  // Create the DI container:
  final di = Klizma();
  // Add a factory for type `Engine`:
  di.add(() => Engine('Vroom!'));
  // Add a named factory for type `Engine`:
  di.add(() => Engine('Whoosh!'), name: 'electric');
  // Add a factory for type `Horn`:
  di.add(() => Horn('Honk!'));
  // Add a factory for type `Car` using default instances of `Engine` and `Horn`:
  di.add(() => Car(di.get<Engine>(), di.get<Horn>()));
  // Add a named factory for type `Car` using the named factory for `Engine`
  // and the default factory for `Horn`:
  di.add(() => Car(di.get<Engine>('electric'), di.get<Horn>()), name: 'tesla');

  // Build an instance of type `Car`
  final car = di.get<Car>();
  /*
  Prints the following:
  =====================
  Engine created.
  Horn created.
  Car created.
  */

  print(car.sound); // Vroom! Honk!

  final tesla = di.get<Car>('tesla');
  /*
  Prints the following. Note that the horn is reused:
  =====================
  Engine created.
  Car created.
  */

  print(tesla.sound); // Whoosh! Honk!
}

class Engine {
  Engine(this.sound) {
    print('Engine created.');
  }

  final String sound;
}

class Horn {
  Horn(this.sound) {
    print('Horn created.');
  }

  final String sound;
}

class Car {
  Car(this.engine, this.horn) {
    print('Car created.');
  }

  final Engine engine;
  final Horn horn;

  String get sound => '${engine.sound} ${horn.sound}';
}
