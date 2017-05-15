import java.util.ArrayList;
/*
 * INITIAL   -- balls that have not undergone reaction yet
 * status == 1   -- balls that are currently increasing in size
 * status == 2 -- balls that are currently decreasing in size
 * status == 3      -- balls that have shrunk to nothing
 */
final ArrayList<Ball> INITIAL   = new ArrayList<Ball>();

final float INITIAL_RADIUS = 30;
final int   GROW           = 1;
final float MAXSIZE        = INITIAL_RADIUS * 5;

// reaction triggered?
boolean reactionStarted = false;

/** Set up the animation.
 */
void setup() {
  //fullScreen();
  size( 600, 600 );
  background(0);
  ellipseMode(CENTER);
  for ( int i = 0; i < 10 + random(40); i++ ) {
    Ball b = new Ball(INITIAL_RADIUS);
    INITIAL.add(b);
  }
}

/** Updates the display.
 * Calculates new states of balls and acts accordingly.
 */
void draw() {
  clear();
  for ( Ball b : INITIAL ) {
    fill(b.COLOR);
    ellipse(b.x, b.y, b.radius, b.radius);
  }

  // only move balls that are not undergoing reaction
  for ( Ball b : INITIAL ) {
    if ( b.status == 0 ) {
      b.move();
    }
  }

  // check if balls are touching
  if ( reactionStarted ) {
    react();
    grow();
    shrink();
  }
}

/** Checks to see if two balls are touching.
 * If so, they start to grow.
 */
void react() {
  // TODO: This is an expensive operation. Optimize?
  for ( int i = 0; i < INITIAL.size(); i++ ) {
    for ( int j = i + 1; j < INITIAL.size(); j++ ) {
      if (INITIAL.get(i).status == 1 || INITIAL.get(i).status == 0) {
        float _dist = dist(
          INITIAL.get(i).x, INITIAL.get(i).y, 
          INITIAL.get(j).x, INITIAL.get(j).y);
        if ( _dist < INITIAL_RADIUS ) {
          // removing min first will alter the position of max
          if ( INITIAL.get(i).status != 2 ) {
            INITIAL.get(i).status = 1;
          }
          if ( INITIAL.get(j).status != 2 ) {
            INITIAL.get(j).status = 1;
          }
        }
      }
    }
  }
}

/** Increases the radius of a ball.
 * If it reaches a maximum size, it starts to shrink.
 */
void grow() {
  for (Ball cur : INITIAL) {
    if ( cur.status == 1 ) {
      cur.radius += 1;
    }
    if ( cur.radius > MAXSIZE ) {
      cur.status = 2;
    }
  }
}

/** Decreases the radius of a ball.
 * If it becomes too small, it disappears.
 */
void shrink() {
  /*
  for (int x = 0; x < INITIAL.size(); x++){
   if ( INITIAL.get(x).status == 2 ){
   INITIAL.get(x).radius -= 1;
   }
   
   if ( INITIAL.get(x).radius < 0 ) {
   INITIAL.remove(x);
   }
   }
   */
  for ( Ball cur : INITIAL ) {
    if ( cur.status == 2 ) {
      cur.radius -= 1;
    }

    if ( cur.radius < 0 ) {
      cur.status = 3;
    }
  }
}

/** Starts the reaction.
 * Makes sure that only one reaction occurs.
 */
void mouseClicked() {
  if (!reactionStarted) {
    reactionStarted = true;
    Ball b = new Ball(INITIAL_RADIUS, mouseX, mouseY);
    b.status = 1;
  }
}