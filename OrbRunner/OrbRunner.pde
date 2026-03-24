int NUM_ORBS = 10; // how many orbs (its ten)
int MIN_SIZE = 10; // smallest an orb can 
int MAX_SIZE = 60; // biggest size alolwed
float MIN_MASS = 10; // minimmum mass 
float MAX_MASS = 200; // max mass 
float G_CONSTANT = 1; // gravitational constant 6.67 * 10 to the power of something i think -11
float D_COEF = 0.1; // drag coefficent

int SPRING_LENGTH = 50; // how long the spring wants to be when its at rest 
float SPRING_K = 0.005; // spring stfifness low means squishy i guess

float LIQUID_DENSITY = 0.0002; // density of the liquid the orbs float in
float WATER_LINE = 330; // y position of the water surface, halfway down the screen
float BUOY_G = 9.81; // gravity constant used for buoyancy calculation

int MOVING   = 0; // index for the moving togle in the array
int BOUNCE   = 1; // index for the bounce togle
int OGRAVITY  = 2; // index for gravity togle
int GGRAVITY = 5; // index for flat gravity toggle...
int DRAGF    = 3; // index for drag togle
int BUOYANCY = 4; // index for buoyancy toggle
int SPRING = 6; // index for spring toggle
boolean[] toggles = new boolean[7]; // all toggles start false everythings off by defalt
String[] modes = {"Moving", "Bounce", "oGravity", "Drag", "Buoyancy", "gGravity", "Spring"}; // labels for displaiyn on screen

FixedOrb earth; // fake earth gravity
Orb[] orbs; // the array that holds all our orbs like the billionaires who hoard all the money
int orbCount; // how many orbs being used

PVector globGravity;


void setup()
{
  size(600, 600);

  makeOrbs(true); //make the orbs 
  earth = new FixedOrb(width/2, height + 200, 10, MAX_MASS); // fixed gravity source below the screen
  globGravity = new PVector(0,2); // pulls downwards. maybe dont use with earth & orbital gravity
}//setup


void draw()
{
  background(255);
  if (toggles[BUOYANCY]) { // only draw water if buoyancy is on
    noStroke();
    fill(0, 100, 255, 80); // semi-transparent blue for the water
    rect(0, WATER_LINE, width, height - WATER_LINE); // water fills from waterline to bottom
  }
  displayMode(); // shows the toggle thingymabobberinators

  for (int o=0; o < orbCount; o++) { // loop thru every orb 
    orbs[o].display(); // draw this orb on screen 

  }//draw orbs & springs

  if (toggles[MOVING]) { // only do physics if moving is toggled on

    for (int o=0; o < orbCount; o++) { // loop thru all orbs for extra forces
      if (toggles[SPRING]) {
        applySprings(); // calc and apply spring force
        if (o < orbCount - 1) { // only draw a spring if theres a next neighbor to connect to
          drawSpring(orbs[o], orbs[o+1]); // draw the spring between this orb and the next one
        }
      }
      if (toggles[GGRAVITY]) {
        orbs[o].applyForce(globGravity); // apply a downwards gravitational force
      }
      if (toggles[OGRAVITY]) { // if gravity is on and earth actually exsists
        PVector grav = orbs[o].getGravity(earth, G_CONSTANT); // get the gravitaional pull toward earth
        orbs[o].applyForce(grav); // apply that force onto the orb
      }
      if (toggles[DRAGF]) { // if drag is toggled on
        PVector drag = orbs[o].getDragForce(D_COEF); // get the drag force for this orb
        orbs[o].applyForce(drag); // apply drag slowin em down the racists and peopel who cant acept changein society
      }
      if (toggles[BUOYANCY]) { // if buoyancy is on
        PVector buoy = orbs[o].getBuoyancy(LIQUID_DENSITY, BUOY_G, WATER_LINE); // get the upward buoyant force
        orbs[o].applyForce(buoy); // push the orb up if its submerged
      }
    }//gravity, drag

    for (int o=0; o < orbCount; o++) { // loop thru again to actualy move everybody
      orbs[o].move(toggles[BOUNCE]); // move the orb bounce if that toggles on
    }
  }//moving
}//draw


void makeOrbs(boolean ordered)
{
   orbCount = NUM_ORBS; // set how many orbs
   orbs = new Orb[orbCount]; // creat a fat array

   if (ordered) { // line of orbs
     for (int i = 0; i < orbCount; i++) { // loop thru each slot
       float x = width/2 - (orbCount/2 * SPRING_LENGTH) + i * SPRING_LENGTH; // space em out evenly from center
       float y = height / 2; // all in the middle of the screen vertically
       float s = random(MIN_SIZE, MAX_SIZE); // random size 
       float m = random(MIN_MASS, MAX_MASS); // random mass
       orbs[i] = (i == 0) ? new FixedOrb(x, y, s, m) : new Orb(x, y, s, m); // first orb is always fixed
     }
   } else { // random positons 
     for (int i = 0; i < orbCount; i++) { // loop trough all of the orbs
       orbs[i] = (i == 0) ? new FixedOrb() : new Orb(); // first orb is always fixed
     }
   }
}//makeOrbs


void drawSpring(Orb o0, Orb o1)
{
  float dist = o0.center.dist(o1.center); // get the distane between the two orbs
  float diff = dist - SPRING_LENGTH; // how far from resting length positive means strecthed

  if (diff > 0) { // spring is stretchd past its resting length
    stroke(255, 0, 0); // red for stretched 
  } else if (diff < 0) { // spring is compressed too close together
    stroke(0, 255, 0); // green for compressed 
  } else { // somehow exactly at rest 
    stroke(0); // black for perfect length 
  }

  strokeWeight(2); // make the line a lil fat so u can actualy see it
  line(o0.center.x, o0.center.y, o1.center.x, o1.center.y); // draw line inbertween
  strokeWeight(1); // reset stroke weight
}//drawSpring


void applySprings()
{
  for (int i = 0; i < orbCount - 1; i++) { // loop thru all adjacent pairs stop one earl
    PVector force = orbs[i].getSpring(orbs[i+1], SPRING_LENGTH, SPRING_K); // get the spring force from i toward i+1
    orbs[i].applyForce(force); // push or pull orb i acordingly
    orbs[i+1].applyForce(PVector.mult(force, -1)); // newtons third law equal and opposit reaction yada yada comething leik taht
  }
}//applySprings


void addOrb()
{
  if (orbCount >= orbs.length) { // if the array is full gotta make more room
    Orb[] bigger = new Orb[orbs.length + 1]; // make a new array one bigger than before
    arrayCopy(orbs, bigger); // copy all the old orbs into the new array
    orbs = bigger; // replace the old array with fatter one
  }
  orbs[orbCount] = new Orb(); // place a new random orb at the next open slot
  orbCount++; // one more row
}//addOrb


void keyPressed()
{
  if (key == ' ') toggles[MOVING]   = !toggles[MOVING]; // flip the moving state
  if (key == 'G') toggles[GGRAVITY] = !toggles[GGRAVITY]; // flip flat gravity
  if (key == 'g') toggles[OGRAVITY]  = !toggles[OGRAVITY]; // flip orbital gravity state
  if (key == 'b') toggles[BOUNCE]   = !toggles[BOUNCE]; // flip bounce state
  if (key == 'd') toggles[DRAGF]    = !toggles[DRAGF]; // flip drag state
  if (key == 'f') toggles[BUOYANCY] = !toggles[BUOYANCY]; // flip buoyancy state
  if (key == 's') toggles[SPRING] = !toggles[SPRING]; // flip spring state

  if (key == '1') makeOrbs(true); // orderd setup 
  if (key == '2') makeOrbs(false); // random setup (fun!!)

  if (key == '-') {
    if (orbCount > 1) { // dont remove the last orb 
      orbCount--; 
    }
  }//removal
  if (key == '=' || key == '+') {
    addOrb(); // aadd orb hat else do you think addOrb() would do
  }//addition
}//keyPressed


void displayMode()
{
  textAlign(LEFT, TOP); // text starts from top left
  textSize(20); 
  noStroke(); // no outlines 
  int x = 0; // start drawing from the left edge

  for (int m=0; m<toggles.length; m++) { // loop thru each toggle to draw its lil box
    fill(toggles[m] ? color(0, 255, 0) : color(255, 0, 0)); // green means go, red means off

    float w = textWidth(modes[m]); // measure how wide the label text is so the box fits
    rect(x, 0, w+5, 20); // draw a lil rectangle behind the text
    fill(0); // switch to black so the text is actualy readable
    text(modes[m], x+2, 2); // write the mode name inside the box
    x+= w+5; // move x over so the next box doesnt overlap this one
  }
}//display
