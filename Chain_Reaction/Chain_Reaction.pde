import java.util.ArrayList;

/* ACTIVE    -- all balls that are not GONE
 * INITIAL   -- balls that have not undergone reaction yet
 * GROWING   -- balls that are currently increasing in size
 * SHRINKING -- balls that are currently decreasing in size
 * GONE      -- balls that have shrunk to nothing
 */
final ArrayList<Ball> ACTIVE    = new ArrayList<Ball>();
final ArrayList<Ball> INITIAL   = new ArrayList<Ball>();
final ArrayList<Ball> GROWING   = new ArrayList<Ball>();
final ArrayList<Ball> SHRINKING = new ArrayList<Ball>();
final ArrayList<Ball> GONE      = new ArrayList<Ball>();

final float INITIAL_RADIUS = 30;
final int   GROW           = 1;
final float MAXSIZE        = INITIAL_RADIUS * 5;

// reaction triggered?
boolean reactionStarted = false;

/** Set up the animation.
 */
void setup() {
  fullScreen();
  background(0);
  ellipseMode(CENTER);
  for ( int i = 0; i < 10 + random(40); i++ ) {
    Ball b = new Ball(INITIAL_RADIUS);
    ACTIVE.add(b);
    INITIAL.add(b);
  }
}

/** Updates the display.
 * Calculates new states of balls and acts accordingly.
 */
void draw() {
  clear();
  for ( Ball b : ACTIVE ) {
    fill(b.COLOR);
    ellipse(b.x, b.y, b.radius, b.radius);
  }

  // only move balls that are not undergoing reaction
  for ( Ball b : INITIAL ) {
    b.move();
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
      float _dist = dist(
          INITIAL.get(i).x, INITIAL.get(i).y,
          INITIAL.get(j).x, INITIAL.get(j).y);
      if ( _dist < INITIAL_RADIUS ) {
        // removing min first will alter the position of max
        GROWING.add(INITIAL.remove(max(i, j)));
        GROWING.add(INITIAL.remove(min(i, j)));
      }
    }
  }
}

/** Increases the radius of a ball.
 * If it reaches a maximum size, it starts to shrink.
 */
void grow() {
  for ( int i = 0; i < GROWING.size(); i++ ) {
    GROWING.get(i).radius += GROW;

    if ( GROWING.get(i).radius > MAXSIZE ) {
      SHRINKING.add(GROWING.remove(i));
    }
  }
}

/** Decreases the radius of a ball.
 * If it becomes too small, it disappears.
 */
void shrink() {
  for ( int i = 0; i < SHRINKING.size(); i++ ) {
    SHRINKING.get(i).radius -= GROW;

    if ( SHRINKING.get(i).radius < 0 ) {
      GONE.add(SHRINKING.remove(i));
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
    ACTIVE.add(b);
    GROWING.add(b);
  }
}

