import 'dart:math';

class UI {
  var backgrounds = ['assets/bg1.json', 'assets/bg2.json', 'assets/bg3.json'];
  var background;
  UI() {
    final _random = new Random();

// generate a random index based on the list length
// and use it to retrieve the element
    this.background = backgrounds[_random.nextInt(backgrounds.length)];
  }
}

class User {}
