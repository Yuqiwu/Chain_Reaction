final Ball[] balls = new Ball[25];

// global boolean to tell whether reaction has been triggered
boolean reactionStarted = false;

void setup() {
  fullScreen();
  background(0);
  for ( int i = 0; i < balls.length; i++ ) {
    balls[i] = new Ball();
  }
}

void draw() {
  clear();
  for ( Ball b : balls ) {
    fill(b.COLOR);
    ellipse(b.x, b.y, b.RADIUS, b.RADIUS);
    b.move();
  }
}

void mouseClicked() {
  if (!reactionStarted) {
    balls[0].x = mouseX;
    balls[1].y = mouseY;
    reactionStarted = true;
  }
}
