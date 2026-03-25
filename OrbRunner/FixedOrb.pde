class FixedOrb extends Orb
{

  /**
   makes a fixedorb at a specific spot with a given size and mass
   */
  FixedOrb(float x, float y, float s, float m)
  {
    super(x, y, s, m); //parent orb
    c = color(255, 0, 0); // red to signal that its a FIXED orb
  }

  /**
   makes a fixedorb at a random spot with a random size and mass
   */
  FixedOrb()
  {
    super(); //random setup
    c = color(255, 0, 0); // red 
  }

  /**
does nothin cuz its a FIXED orb
does jack shit
   */
  void move(boolean bounce)
  {
    //do nothing
  }
}//fixedOrb
