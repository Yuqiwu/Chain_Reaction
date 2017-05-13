class Ball {
  final float RADIUS = 10;
  final color COLOR = color(random(256), random(256), random(256));

  float x = random((width-RADIUS) + RADIUS/2);
  float y = random((height-RADIUS) + RADIUS/2);
  float dx = random(10) - 5;
  float dy = random(10) - 5;
  int state;

  Ball() {
  }

  void move() {
    x += dx;
    y += dy;
    if ( x < 0 || x > width || y < 0 || y > height ) {
      float temp = dx;
      dx = -dy;
      dy = temp;
    }
  }
}

