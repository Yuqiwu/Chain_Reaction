Ball[] balls;

// global boolean to tell whether reaction has been triggered
boolean reactionStarted = false;

void setup() {
  fullScreen();
  balls  = new Ball[25];
  for ( int i = 0; i < balls.length; i++ ) {
    balls[i] = new Ball();
  }
}



void draw() {
  background(0);  
  for ( Ball b : balls ) {
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