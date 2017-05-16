import java.util.ArrayList;

/* ALL       -- all visible balls
 * INITIAL   -- balls that have not undergone reaction yet
 * ACTIVE    -- balls that are reacting
 * GROWING   -- balls that are currently increasing in size
 * SHRINKING -- balls that are currently decreasing in size
 */
final ArrayList<Ball> ALL       = new ArrayList<Ball>();
final ArrayList<Ball> INITIAL   = new ArrayList<Ball>();
final ArrayList<Ball> GROWING   = new ArrayList<Ball>();
final ArrayList<Ball> SHRINKING = new ArrayList<Ball>();
final ArrayList<Ball> ACTIVE    = new ArrayList<Ball>();

final float INITIAL_RADIUS = 30;
final int   GROW           = 1;
final float MAXSIZE        = INITIAL_RADIUS * 5;

// reaction triggered?
boolean reactionStarted = false;

/** Set up the animation.
 */
@Override
void setup() {
  fullScreen();
  background(0);
  noStroke();
  ellipseMode(CENTER);
  for ( int i = 0; i < 100 + random(100); i++ ) {
    Ball b = new Ball(INITIAL_RADIUS);
    ALL.add(b);
    INITIAL.add(b);
  }
}

/** Updates the display.
 * Calculates new states of balls and acts accordingly.
 */
@Override
void draw() {
  clear();
  for ( Ball b : ALL ) {
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

  if ( ALL.size() == 0 ) {
    exit();
  }

  if ( ACTIVE.size() == 0 ) {
    reactionStarted = false;
  }
}

/** Checks to see if two balls are touching.
 * If so, they start to grow.
 */
void react() {
  // TODO: This is an expensive operation. Optimize?
  for ( int i = 0; i < ACTIVE.size(); i++ ) {
    for ( int j = 0; j < ALL.size(); j++ ) {
      float _dist = dist(
          ACTIVE.get(i).x, ACTIVE.get(i).y,
          ALL.get(j).x, ALL.get(j).y);
      float _rad = (ACTIVE.get(i).radius + ALL.get(j).radius) / 2;

      if ( _dist <= _rad ) {
        // only add balls if they haven't started growing yet
        Ball _j = ALL.get(j);
        if ( INITIAL.remove(_j) ) {
          ACTIVE.add(_j);
          GROWING.add(_j);
        }
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
      ALL.remove(SHRINKING.remove(i));
      ACTIVE.remove(i);
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
    ALL.add(b);
    ACTIVE.add(b);
    GROWING.add(b);
  }
}

