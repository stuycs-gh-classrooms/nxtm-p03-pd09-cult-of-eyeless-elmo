class Orb
{

  //instance variables
  PVector center;
  PVector velocity;
  PVector acceleration;
  float bsize;
  float mass;
  color c;


  Orb()
  {
    bsize = random(MIN_SIZE, MAX_SIZE); // bsiz eis  arandom number form 10 to whatever the hell max size is
    float x = random(bsize/2, width-bsize/2); // x is a random number based off of the size of the ball and the width
    float y = random(bsize/2, height-bsize/2);// same as x but instead of width its height  
    center = new PVector(x, y); // radnom set of coordnates based off of x and y
    mass = random(MIN_MASS, MAX_MASS);//sets random mass from 10 to 100
    velocity = new PVector();//empty pvectore to be modified later on
    acceleration = new PVector();//same as velocity
    setColor();//color
  }


  Orb(float x, float y, float s, float m)
  {
    bsize = s; // settin the size 
    mass = m; // mass goes here
    center = new PVector(x, y); // put in x and y into a pvector
    velocity = new PVector(); // zeroed out velcoity
    acceleration = new PVector(); // zeroed accel 
    setColor(); // pick a color 
  }


  void move(boolean bounce)
  {
    if (bounce) { // if bouncin is on do the wall check thingymabob
      xBounce(); // dont let the orb fly off the sides
      yBounce(); // or the top and bottmo
    }

    velocity.add(acceleration); // add accel to vel so the orb actualy moves
    center.add(velocity); // move the center by the velocity wow physics
    acceleration.mult(0); // reset accel to zero 
  }//move


  void applyForce(PVector force)
  {
    acceleration.add(PVector.div(force, mass)); // divide by mass cuz f=ma => a=f/m 
  }


  PVector getDragForce(float cd)
  {
    float speed = velocity.mag(); // get the speed just the magnitude not direciton
    if (speed == 0) return new PVector(); // no velocity means no drag, avoid normalizing a zero vector
    float dragMag = -0.5 * speed * speed * cd; // drag formula 
    return PVector.mult(velocity.normalize(null), dragMag); // multiply by drag magnitude 
  }


  PVector getGravity(Orb other, float G)
  {
    float strength = G * mass*other.mass; // gravitaional force scales with both masses
    float r = max(center.dist(other.center), MIN_SIZE); // distane between orbs min size
    strength = strength / (r * r); // strength falls off with distace squared inverse square law
    PVector force = PVector.sub(other.center, center); // subtract our postion to get the directoin vector toward other
    force.normalize();
    force.mult(strength); // scale by strength 
    return force; // garvity 
  }

  PVector getSpring(Orb other, int springLength, float springK)
  {
    PVector direction = PVector.sub(other.center, center); // subtract our positon to get the vector from us to other
    float currentDist = direction.mag(); // how far apart 
    float displacement = currentDist - springLength; // how much the spring is strecthed or squished
    direction.normalize(); // turn it into a unit vector so we can scale it proper
    direction.mult(springK * displacement); // f=kx multiply by spring constatn and displcement
    return direction; // spinge force
  }//getSpring


  PVector getBuoyancy(float liquidDensity, float gravity, float waterLine)
  {
    float area = PI * (bsize/2) * (bsize/2); // area of the circle (2D version of volume)
    float submergedFraction = constrain((center.y + bsize/2 - waterLine) / bsize, 0, 1); // how much of the orb is below the waterline, 0 to 1
    float submergedArea = area * submergedFraction; // only the submerged portion displaces liquid
    float buoyMag = liquidDensity * submergedArea * gravity; // F = p * v * g upward force
    return new PVector(0, -buoyMag); // buoyancy always pushes straight up
  }//getBuoyancy


  boolean yBounce()
  {
    if (center.y > height - bsize/2) { // if the orb hits the bottm edge
      velocity.y *= -1; // flip y velocity to make it "bounce"
      center.y = height - bsize/2; // clamp it 

      return true; // yep it bounced
    }//bottom bounce
    else if (center.y < bsize/2) { // hit the top edge 
      velocity.y*= -1; // flip it again 
      center.y = bsize/2; // clamp to top 
      return true; // bounced again good boy
    }
    return false; // didnt hit anything
  }//yBounce


  boolean xBounce()
  {
    if (center.x > width - bsize/2) { // hit the right wall rude
      center.x = width - bsize/2; // shove it back inside the border
      velocity.x *= -1; // flip horizontla velocity
      return true; // bounced off the right
    } else if (center.x < bsize/2) { // hit the left wall a
      center.x = bsize/2; // clamp to left edge
      velocity.x *= -1; // flip it back the other way
      return true; // bounced off the left
    }
    return false; // no bounce 
  }//xbounce


  boolean collisionCheck(Orb other)
  {
    return ( this.center.dist(other.center)
      <= (this.bsize/2 + other.bsize/2) ); // if distanec is less than sum of radii theyre touchin u
  }//collisionCheck


  void setColor()
  {
    color c0 = color(0, 255, 255); // cyan for the small vorbs
    color c1 = color(0); // black for the FAT ones
    c = lerpColor(c0, c1, (mass-MIN_MASS)/(MAX_MASS-MIN_MASS)); //c is a color inbetween c0 and c1 
  }//setColor


  //visual behavior
  void display()
  {
    noStroke(); // no outline we arent animals
    fill(c); // fill with the orbs color whatever setColor decided
    circle(center.x, center.y, bsize); // draw the damn circle 
    fill(0); // switch to black for text just in case
  }//display
}//Ball
