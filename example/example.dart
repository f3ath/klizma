import 'package:klizma/klizma.dart';

void main() {
  final di = Klizma();
  di.add(() => Engine('Vroom!'));
  di.add(() => Engine('Whoosh!'), name: 'electric');
  di.add(() => Horn('Honk!'));
  di.add(() => Car(di.get<Engine>(), di.get<Horn>()));
  di.add(() => Car(di.get<Engine>('electric'), di.get<Horn>()), name: 'tesla');

  final car = di.get<Car>();
  /*
  Prints the following:
  =====================
  Engine: Vroom!
  Horn: Honk!
  Car: Vroom! Honk!
  */

  final tesla = di.get<Car>('tesla');
  /*
  Prints the following. Note that the horn is reused:
  =====================
  Engine: Whoosh!
  Car: Whoosh! Honk!
  */

  print(car.sound); // Vroom! Honk!
  print(tesla.sound); // Whoosh! Honk!
}

class Engine {
  Engine(this.sound) {
    print('Engine: $sound');
  }

  final String sound;
}

class Horn {
  Horn(this.sound) {
    print('Horn: $sound');
  }

  final String sound;
}

class Car {
  Car(Engine engine, Horn horn) : sound = '${engine.sound} ${horn.sound}' {
    print('Car: $sound');
  }

  final String sound;
}
