
// --------------------------------------------------The forces of this world
final float radMin = 10;             // Minimum Square rad
final float radMax = 32;             // Maximum Square rad
final float velYJump = 25;           // The amount of jumping
final float velYFall = 4;            // The amount of isJumping force
final float velXMove = 30;           // The force of moving forward
final float accYGrav = 10;           // The grav of the world
final float fricAir = 1;             // The air friction. Limits velocity
final float fricSolFact = 0.85;      // The surface friction. Limits velocity
final float jumpRot = PI/4;          // The radiant jump rotation
final float density = 1.7;           // The density per size unit
final float damping = 0;             // The object's force absorber factor
final float sinkRate = 0;            // How fast the ground sinks


// ----------------------------------------------------------The Square class
class Square {
  float hue;                         // Color in  HUE value
  float rad;                         // The radius of the square
  float posX, posY;                  // The x- and y-coordonars
  float oPosX, oPosY;                // The x- and y-coordonars old
  float limDispLeft, limDispRight;   // The x-axis screen borders
  float limDispUp, limDispDown;      // The y-axis screen borders
  float limDown;                     // The y-axis down border
  float accX, accY;                  // The x- and y-axis acc
  float velX, velY;                  // The x- and y-axis velocity
  float cVelUp, cVelDown, cVelX;     // The y-axis moving velocity
  float velYMax;                     // The y-axis maximum velocity
  float cumulatedSinking = 0;        // This goes to 1 and back
  boolean isJumping;                 // Is falling or fallen
  boolean isSeated;                  // Is on top of another
  boolean isOnGround;                // Is on the ground
  boolean isHookedLeft;              // Is hooked on the left wall
  boolean isHookedRight;             // Is hooked on the right wall
  boolean isSlidingDown;             // Is slinding down the wall
  boolean isCrawlingUp;              // Is crawling up the wall


  // ---------------------------------------------------------Player Movement
  void moveLeft(float amount) {
    oPosX = posX;
    cVelX *= amount;
    isHookedRight = false;
    if (getBorderLeft() - cVelX <= 0) {
      posX = limDispLeft;
      isHookedLeft = true;
    } 
    else {
      posX -= cVelX;
      isHookedLeft = false;
    }
  }

  void moveRight(float amount) {
    oPosX = posX;
    cVelX *= amount;
    isHookedLeft = false;
    if (getBorderRight() + cVelX >= width) {
      posX = limDispRight;
      isHookedRight = true;
    } 
    else {
      posX += cVelX;
      isHookedRight = false;
    }
  }

  void moveUp( float amount ) {
    if ( !isJumping && isOnGround ) {
      cVelUp *= amount;
      isJumping = true;
      isOnGround = false;
      velY = -cVelUp;
    }
  }

  void moveDown(float amount) {
    cVelDown *= amount;
    velY += cVelDown;
  }

  void freeFall() {
    isJumping = false;
  }


  // ---------------------------------------------------------The update loop
  void update() {
    oPosY = posY;
    cVelX = velX;
    cVelUp = velYJump;
    cVelDown = velYFall;

    limDown = isSeated ? limDown : limDispDown;

    cumulatedSinking += sinkRate;
    if (cumulatedSinking >= 1) {
      limDispDown += cumulatedSinking;
      cumulatedSinking = 0;
    }

    if ( isHookedLeft || isHookedRight ) {
      if ( velY < 0 ) {
        velY = velY * fricSolFact;
        velY += accY * fricSolFact;
      }
      else
        velY = ( velY + accY ) * fricSolFact;
    }
    else
      velY += accY;

    if ((posY + velY) > limDown) {
      velY = velY * -damping;
      posY = limDown;
      isOnGround = true;
    }
    else
      posY += velY;
  }


  // --------------------------------------------------------------Colisions
  void checkCollisions() {
    isSeated = false;
    for (Square s : squares) {
      if (s == this) continue;
      float radSum = getRadSum(s);
      float oldAngle = getDegrees(s);

      // Down Collision
      if (oldAngle > -135 && -45 > oldAngle && getDistX(s) < radSum) {
        if (getBorderDown() >= s.getBorderUp()) {
          isSeated = true;
          if (oPosY != posY) {
            limDown = s.posY - radSum;
            posY = limDown;
          }
        }
      }

      // Up Collision
      else if (oldAngle < 135 && 45 < oldAngle && getDistX(s) < radSum) {
        if (getBorderUp() <= s.getBorderDown() && !isOnGround) {
          if (oPosY != posY) {
            posY = s.posY + radSum;
          }
        }
      }

      // Left Collision
      else if (oldAngle > -45 && 45 > oldAngle && getDistY(s) < radSum) {
        if (getBorderLeft() <= s.getBorderRight()) {
          if (oPosX != posX) {
            posX = s.posX + radSum; /*oPosX - getDistToLeft(s);*/
          }
        }
      }

      // Right Collision
      else if (oldAngle < -135 || 135 < oldAngle && getDistY(s) < radSum) {
        if (getBorderRight() >= s.getBorderLeft()) {
          if (oPosX != posX) {
            posX = s.posX - radSum; /*oPosX + getDistToRight(s);*/
          }
        }
      }
    }
  }


  // -------------------------------------------------------Square Proximity
  float getDegrees(Square s) {
    return degrees(atan2(oPosY - s.posY, oPosX - s.posX));
  }

  float getDistX(Square s) {
    return abs(posX - s.posX);
  }

  float getDistY(Square s) {
    return abs(posY - s.posY);
  }

  float getDistToRight(Square s) {
    return s.getBorderLeft() - getBorderRight();
  }

  float getDistToLeft(Square s) {
    return getBorderLeft() - s.getBorderRight();
  }

  float getRadSum(Square s) {
    return rad + s.rad;
  }

  float getBorderLeft() {
    return posX - rad;
  }

  float getBorderRight() {
    return posX + rad;
  }

  float getBorderUp() {
    return posY - rad;
  }

  float getBorderDown() {
    return posY + rad;
  }


  // --------------------------------------------------------Paint the pretty
  void display() {
    oPosX = posX;
    oPosY = posY;

    if ( !isOnGround && !isHookedLeft && !isHookedRight ) {
      pushMatrix( );
      translate( posX, posY );
      rotate( jumpRot );
      fill( width % hue, width, width );
      rect( 0, 0, rad, rad );
      popMatrix( );
    }
    else {
      fill( hue, width, width );
      rect( posX, posY, rad, rad );
    }
  }


  // ----------------------------------------------------A casual constructor
  Square(float x, float y, float r, float h) {
    oPosX = posX = x;
    oPosY = posY = y;
    rad = r; 
    hue = h;
    accY = (density * rad) / accYGrav;
    velX = (density / rad) * velXMove;
    limDispLeft = rad;
    limDispRight = width - rad;
    limDispUp = rad;
    limDispDown = height - rad;
    limDown = limDispDown;
    isJumping = true;
    isSeated = false;
    isOnGround = false;
  }
}


//------------------------------------------------------------To be continued

