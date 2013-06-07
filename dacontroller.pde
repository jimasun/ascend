
/* 
 * DAController is a wrapper class for use with the proCONTROLL joystick library
 * written by Christian Riekoff for Processing. It encapsulates the two analog 
 * sticks and all the buttons found on a typical dual analog controller.
 * 
 * proCONTROLL:  http://creativecomputing.cc/p5libs/procontroll/
 * DAController: http://code.compartmental.net/dualanalog/
 *
 * Modified by Marius Jigoreanu on 2013.01.08 23:11
 */

import procontroll.*;
import net.java.games.input.*;

class DAController {

  private ControllDevice gamepad;
  private ControllCoolieHat DPad;
  private ControllSlider XBOXTrig;
  private ControllStick leftStick;
  private ControllStick rightStick;

  private ControllButton X;
  private ControllButton C;
  private ControllButton T; 
  private ControllButton S;
  private ControllButton L1;
  private ControllButton L2;
  private ControllButton L3;
  private ControllButton R1;
  private ControllButton R2;
  private ControllButton R3;
  private ControllButton Select;
  private ControllButton Start;
  private ControllButton Up;
  private ControllButton Down;
  private ControllButton Left;
  private ControllButton Right;

  public boolean invertLeftX;
  public boolean invertLeftY;
  public boolean invertRightX;
  public boolean invertRightY;

  // --------------------------------------------- Constructor
  DAController(ControllDevice d) {
    gamepad = d;
    if ( gamepad.getName().equals("USB Force Feedback Joypad (MP-8888)") ) {
      mapJoybox();
    }
    else if ( gamepad.getName().equals("Logitech Dual Action USB") ) {
      mapLogitech();
    }
    else if ( gamepad.getName().equals("4 axis 16 button joystick") ) {
      mapGeneric();
    }
    else if ( gamepad.getName().equals("Controller (XBOX 360 For Windows)") ) {
      mapXBOX360();
    }
    else {
      println("Unrecognized device name, using Logitech mapping.");
      mapLogitech();
    }
    invertLeftX = invertLeftY = invertRightX = invertRightY = false;
  }
  // --------------------------------------------- Constructor


  // --------------------------------------------- Joypad
  private void mapJoybox() {
    gamepad.printSticks();
    gamepad.printButtons();
    leftStick = gamepad.getStick(1);
    rightStick = gamepad.getStick(0);
    T = gamepad.getButton(0);
    C = gamepad.getButton(1);
    X = gamepad.getButton(2);
    S = gamepad.getButton(3);
    R1 = gamepad.getButton(7);
    R2 = gamepad.getButton(5);
    R3 = gamepad.getButton(11);
    L1 = gamepad.getButton(6);
    L2 = gamepad.getButton(4);
    L3 = gamepad.getButton(10);
    DPad = gamepad.getCoolieHat(12);
    Select = gamepad.getButton(9);
    Start = gamepad.getButton(8);
  }    
  // --------------------------------------------- Joypad


  // --------------------------------------------- Logitech
  private void mapLogitech() {
    gamepad.printSticks();
    gamepad.printButtons();
    leftStick = gamepad.getStick(1);
    rightStick = gamepad.getStick(0);
    T = gamepad.getButton(4);
    C = gamepad.getButton(3);
    X = gamepad.getButton(2);
    S = gamepad.getButton(1);
    R1 = gamepad.getButton(6);
    R2 = gamepad.getButton(8);
    R3 = gamepad.getButton(12);
    L1 = gamepad.getButton(5);
    L2 = gamepad.getButton(7);
    L3 = gamepad.getButton(11);
    DPad = gamepad.getCoolieHat(0);
    Select = gamepad.getButton(9);
    Start = gamepad.getButton(10);
  }
  // --------------------------------------------- Logitech


  // --------------------------------------------- Generic
  private void mapGeneric() {
    gamepad.printSticks();
    gamepad.printButtons();
    leftStick = gamepad.getStick(0);
    rightStick = gamepad.getStick(1);
    T = gamepad.getButton(0);
    C = gamepad.getButton(1);
    X = gamepad.getButton(2);
    S = gamepad.getButton(3);
    R1 = gamepad.getButton(7);
    R2 = gamepad.getButton(5);
    R3 = gamepad.getButton(10);
    L1 = gamepad.getButton(6);
    L2 = gamepad.getButton(4);
    L3 = gamepad.getButton(9);
    Up = gamepad.getButton(12);
    Right = gamepad.getButton(13);
    Down = gamepad.getButton(14);
    Left = gamepad.getButton(15);
    Select = gamepad.getButton(8);
    Start = gamepad.getButton(11);
  }
  // --------------------------------------------- Generic


  // --------------------------------------------- XBox 360
  private void mapXBOX360() {
    gamepad.printSliders();
    gamepad.printButtons();
    leftStick = new ControllStick(gamepad.getSlider(1), gamepad.getSlider(0));
    rightStick = new ControllStick(gamepad.getSlider(3), gamepad.getSlider(2));
    XBOXTrig = gamepad.getSlider(4);
    T = gamepad.getButton(3);
    C = gamepad.getButton(1);
    X = gamepad.getButton(0);
    S = gamepad.getButton(2);
    R1 = gamepad.getButton(5);
    R3 = gamepad.getButton(9);
    L1 = gamepad.getButton(4);
    L3 = gamepad.getButton(8);
    DPad = gamepad.getCoolieHat(10);
    Select = gamepad.getButton(6);
    Start = gamepad.getButton(7);
  }
  // --------------------------------------------- XBox 360


  // --------------------------------------------- Vibration
  void rumble(float amt) {
    gamepad.rumble(amt);
  }

  void rumble(float amt, int id) {
    gamepad.rumble(amt, id);
  }
  // --------------------------------------------- Vibration


  // --------------------------------------------- Left & Right Stick
  float leftX() {
    int i = (invertLeftX ? -1 : 1);
    return leftStick.getX()*i;
  }

  float rightX() {
    int i = (invertRightX ? -1 : 1);
    return rightStick.getX()*i;
  }

  float leftY() {
    int i = (invertLeftY ? 1 : -1);
    return leftStick.getY()*i;
  }

  float rightY() {
    int i = (invertRightY ? 1 : -1);
    return rightStick.getY()*i;
  }

  boolean leftZ() {
    return L3.pressed();
  }

  boolean rightZ() {
    return R3.pressed();
  }
  // --------------------------------------------- Left & Right Stick


  // --------------------------------------------- Buttons
  boolean T() { 
    return T.pressed();
  }

  boolean C() { 
    return C.pressed();
  }

  boolean X() { 
    return X.pressed();
  }

  boolean S() { 
    return S.pressed();
  }
  // --------------------------------------------- Buttons


  // --------------------------------------------- Shoulder
  boolean L1() { 
    return L1.pressed();
  }

  float L2() {
    if ( XBOXTrig != null ) {
      println(" left: " + XBOXTrig.getValue());
      if (XBOXTrig.getValue() > 0)
        return XBOXTrig.getValue();
      else return 0;
    }
    else if ( L2 != null ) {
      if ( L2.pressed() )
        return 1;
      else return 0;
    }
    else return 0;
  }

  boolean R1() { 
    return R1.pressed();
  }

  float R2() {
    if ( XBOXTrig != null ) {
      println(" right: " + -XBOXTrig.getValue());
      if ( -XBOXTrig.getValue() < 0 )
        return -XBOXTrig.getValue();
      else return 0;
    }
    else if ( R2 != null ) {
      if ( R2.pressed() )
        return 1;
      else return 0;
    }
    else return 0;
  }

  // --------------------------------------------- Shoulder


  // --------------------------------------------- Start/ Select
  boolean Start() { 
    return Start.pressed();
  }

  boolean Select() { 
    return Select.pressed();
  }
  // --------------------------------------------- Start/ Select


  // --------------------------------------------- D-pad
  boolean DUp() {
    if ( Up != null ) return Up.pressed();
    else if ( DPad != null ) return DPad.getY() < 0;
    else return false;
  }

  boolean DDown() {
    if ( Down != null ) return Down.pressed();
    else if ( DPad != null ) return DPad.getY() > 0;
    else return false;
  }

  boolean DLeft() {
    if ( Left != null ) return Left.pressed();
    else if ( DPad != null ) return DPad.getX() < 0;
    else return false;
  }

  boolean DRight() {
    if ( Right != null ) return Right.pressed();
    else if ( DPad != null ) return DPad.getX() > 0;
    else return false;
  }
  // --------------------------------------------- D-pad
}

