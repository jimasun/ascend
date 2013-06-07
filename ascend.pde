
import procontroll.*;
import net.java.games.input.*;


// -------------------------------------Interaction variables: mouse, keys
DAController daController;           // Controller input class
float pressX, pressY;                // Current mouse press coord
float oPressX, oPressY;              // Previous mouse press coord
float cSquareRad;                    // Current spawning square rad
float sLocX, sLocY = 32;             // Static UI x and y-axis
float spawnLocX, spawnLocY;          // Location of the spawining square
float controllTolerance = 0.2;       // Under this value input is ignored

final int StateIntro = 0;            // Game state for intro screen
final int StatePlay = 1;             // Game state for playing
final int StateEnd = 2;              // Game state for game over
int cGameState;                      // Current game state

Square square;                       // The one moving square
ArrayList<Square> squares;           // All the square that will be
final int crowdNo = 10;              // The no of initial crowd


// -------------------------------The setup(), one-time run initialization
void setup() {
  size(500, 730);
  smooth();
  noStroke();
  colorMode(HSB, width, width, width);
  rectMode(RADIUS);
  textFont(createFont("DejaVuSansMono-Bold.ttf", 32));
  try {
    ControllDevice cd = ControllIO.getInstance(this)
      .getDevice("Controller (XBOX 360 For Windows)");
    cd.setTolerance(controllTolerance);
    daController = new DAController(cd);
  }
  catch(Exception e) {
    println("\"Controller (XBOX 360 For Windows)\" not detected. Use WASD.");
  }
  sLocX = width / 2;
  squares = new ArrayList();
  createFirstSet();
  cGameState = StatePlay;
}


// ---------------------------------------The game loop, foreever and ever
void draw() {
  processInput();

  background(0);
  switch(cGameState) {

  case StateIntro:
    drawIntro();
    break;

  case StatePlay:
    for (Square s : squares)
      s.update();
    for (Square s : squares)
      s.checkCollisions();
    for (Square s : squares)
      s.display();
    if (mousePressed)
      drawSpawning();
    drawStatics();
    break;

  case StateEnd:
    drawEnd();
  }
}


// -------------------------------------------------------Create the crowd
void createFirstSet() {
  for (int i = 0; i < crowdNo; i++) {
    oPressX = random(0, width);
    oPressY = 0;
    checkSquareSize();
    cSquareRad = random(radMin, radMax + 1);
    square = new Square(
      pressX, pressY, cSquareRad, oPressX);
    if (i < crowdNo - 1)
      square.limDispDown = random(0, height);
    squares.add(square);
  }
}


// ----------------------------------------------------Display the counter
void drawStatics() {
  int size = squares.size();
  String padding = size < 10 ? padding = "0" : "";
  fill(mouseX, width, width);
  textSize(36);
  textAlign(CENTER);
  text(padding + squares.size(), sLocX, sLocY);
  fill(mouseX, width, width, 50);
  rect(0, 0, width, 40);
}

// ------------------------------------------------------Display the Intro
final String iLine1 = "1. Get at the top of the area!\n";
final String iLine2 = "2. You can only move last spawned square!\n";
final String iLine3 = "3. Use WASD to move about!\n";
final String iLine4 = "4. Use the MOUSE to spawn new squaren!\n";
final String iLine5 = "5. OMG! we are sinking!\n";
final String iLine6 = "6. At least one of us must survive!\n";
final String iLine7 = "7. ENTER NOW!";

void drawIntro() {
  fill(mouseX, width, width, 150);
  textAlign(CENTER);
  textLeading(30);
  textSize(18);
  text(iLine1 + iLine2 + iLine3 + iLine4 + iLine5 + iLine6 + iLine7, 
  sLocX, 300);
}


// ---------------------------------------------------------Display Ending
final String eLine1 = "1. You sacrificed for the good of the tribe\n";
final String eLine2 = "2. \n";
final String eLine3 = "3. \n";
final String eLine4 = "4. \n";
final String eLine5 = "5. \n";
final String eLine6 = "6. \n";

void drawEnd() {
  drawStatics();
}


// ---------------------------------------------Compute the spawning point
float getSpawningX() {
  float maxX = radMin;
  for (int i = 0; i < squares.size(); i++) {
    if ((squares.get(i).posY + squares.get(i).rad) > maxX)
      maxX = squares.get(i).posY;
  }
  return maxX;
}

float getSpawningY() {
  float maxY = radMin;
  for (int i = 0; i < squares.size(); i++) {
    if ((squares.get(i).posY + squares.get(i).rad) > maxY)
      maxY = squares.get(i).posY;
  }
  return maxY;
}


// -----------------------------------------------The Mouse Event Handlers
void mousePressed() {
  if (cGameState == StatePlay) {
    oPressX = mouseX;
    oPressY = mouseY;
    checkSquareSize();
  }
}

// Resize the square when the mouse is dragged
void mouseDragged() {
  if (cGameState == StatePlay) {
    checkSquareSize();
  }
}

// Save the square when button is released
void mouseReleased() {
  if (cGameState == StatePlay) {
    square = new Square(
    pressX, pressY, cSquareRad, mouseX);
    squares.add(square);
  }
}

// Adjust the size of the Square when interacting
void checkSquareSize() {
  cSquareRad = (float)mouseY / height * radMax;
  if (cSquareRad < radMin)
    cSquareRad = radMin;
  if (cSquareRad > radMax)
    cSquareRad = radMax;

  pressX = oPressX;
  pressY = oPressY;
  if (pressX < cSquareRad)
    pressX = cSquareRad;
  if (pressX > width - cSquareRad)
    pressX = width - cSquareRad;
  if (pressY < cSquareRad)
    pressY = cSquareRad;
  if (pressY > height - cSquareRad)
    pressY = height - cSquareRad;
}

void drawSpawning() {
  fill(mouseX, width, width);
  rect(pressX, pressY, cSquareRad, cSquareRad);
}


// -------------------------------------------The Custom Key Event Handler
boolean pKeys[] = new boolean[4];
final int keyW = 0, keyA = 1, keyD = 2, keyS = 3;

void keyPressed() {
  if (key == 'w') 
    pKeys[keyW] = true;
  if (key == 'a') 
    pKeys[keyA] = true;
  if (key == 'd') 
    pKeys[keyD] = true;
  if (key == 's') 
    pKeys[keyS] = true;
  if (key == ENTER)
    setup();
}

void keyReleased() {
  if (key == 'w') 
    pKeys[keyW] = false;
  if (key == 'a') 
    pKeys[keyA] = false;
  if (key == 's') 
    pKeys[keyS] = false;
  if (key == 'd') 
    pKeys[keyD] = false;
}


void processInput() {
  if (daController != null) {
    if (daController.Start())
      setup();
    if (daController.Select())
      cGameState = StateIntro;
  }

  if (square == null) return;
  boolean isUp, isLeft, isDown, isRight;
  isUp = isLeft = isDown = isRight = false;
  float aUp, aLeft, aDown, aRight;
  aUp = aLeft = aDown = aRight = 1;

  if (daController != null) {
    if (pKeys[keyW] || daController.X() || daController.C() || daController.S() || 
      daController.T() || daController.L1() || daController.R1() || daController.leftZ() || 
      daController.rightZ() || daController.DUp() || daController.leftY() > 0 || 
      daController.rightY() > 0) isUp = true;
    if (pKeys[keyA] || daController.DLeft() || daController.leftX() < 0 || 
      daController.rightX() < 0) isLeft = true;
    if (pKeys[keyS] || daController.DDown() || daController.leftY() < 0 || 
      daController.rightY() < 0) isDown = true;
    if (pKeys[keyD] || daController.DRight() || daController.leftX() > 0 || 
      daController.rightX() > 0) isRight = true;

    aUp = (daController.leftY() > 0) ? abs(daController.leftY()) : aUp;
    aLeft = (daController.leftX() < 0) ? abs(daController.leftX()) : aLeft;
    aDown = (daController.leftY() < 0) ? abs(daController.leftY()) : aDown;
    aRight = (daController.leftX() > 0) ? abs(daController.leftX()) : aRight;

    aUp = (daController.rightY() > 0) ? abs(daController.rightY()) : aUp;
    aLeft = (daController.rightX() < 0) ? abs(daController.rightX()) : aLeft;
    aDown = (daController.rightY() < 0) ? abs(daController.rightY()) : aDown;
    aRight = (daController.rightX() > 0) ? abs(daController.rightX()) : aRight;
  }

  if (pKeys[keyW] || isUp) square.moveUp(aUp); 
  else square.freeFall();
  if (pKeys[keyA] || isLeft) square.moveLeft(aLeft);
  if (pKeys[keyS] || isDown) square.moveDown(aDown);
  else square.freeFall();
  if (pKeys[keyD] || isRight) square.moveRight(aRight);
}


//---------------------------------------------------------To be continued

