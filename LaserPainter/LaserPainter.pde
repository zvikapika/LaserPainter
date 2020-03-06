import processing.serial.*;
import java.util.*;

final boolean LIVE = true;

final String PORT_NAME = "COM44";

final int BORDER_WEIGHT = 5;

final float LASER_ORIGIN_X = 0;
final float LASER_WIDTH = 220;  // mm
final float LASER_ORIGIN_Y = 0;
final float LASER_HEIGHT = 170; // mm
final float LASER_ASPECT_RATIO = (LASER_WIDTH - LASER_ORIGIN_X) / (LASER_HEIGHT - LASER_ORIGIN_Y);

float CANVAS_WIDTH;  // calculated at runtime
float CANVAS_HEIGHT; // calculated at runtime

//String START_LASER = "M3 S255";
String START_LASER = "M3 S";
String STOP_LASER = "M5";
String JOG_COMMAND = "G0";
String BURN_COMMAND = "G1";

GCodeDispatcher dispatcher;
LaserCanvas laserCanvas;
CommandPanel commandPanel;

void setup() {
  fullScreen();
  background(255);
  strokeWeight(2);
  frameRate(120);
}

boolean screenInitialized = false;

void draw() {
  if (!screenInitialized) {
    if (width > 0) {
      CANVAS_WIDTH  = width;
      CANVAS_HEIGHT = CANVAS_WIDTH / LASER_ASPECT_RATIO;
      while (CANVAS_HEIGHT > height) {
        CANVAS_WIDTH--;
        CANVAS_HEIGHT = CANVAS_WIDTH / LASER_ASPECT_RATIO;
      }
      println("canvas size set to: " + CANVAS_WIDTH + " x " + CANVAS_HEIGHT);
      commandPanel = new CommandPanel((int)CANVAS_WIDTH);
      dispatcher = new GCodeDispatcher(commandPanel, PORT_NAME, LIVE);
      laserCanvas = new LaserCanvas(0, 0, (int)CANVAS_WIDTH, (int)CANVAS_HEIGHT, dispatcher, commandPanel);
      new Thread(dispatcher).start();
      screenInitialized = true;
    }
    return;
  }
  laserCanvas.draw();
  commandPanel.draw();

  if (mousePressed) {
    PVector point = new PVector(mouseX, mouseY);
    if (laserCanvas.contains(point)) {
      laserCanvas.handle(point);
    } 
    else if (commandPanel.contains(point)) {
      commandPanel.handle(point);
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    laserCanvas.clear();
  }
}

void mouseReleased() {
  PVector point = new PVector(mouseX, mouseY);
  if (laserCanvas.contains(point)) {
    laserCanvas.handleReleased();
  } 
  else if (commandPanel.contains(point)) {
    commandPanel.handleReleased(point);
  }
}

void mousePressed() {
  PVector point = new PVector(mouseX, mouseY);
  if (laserCanvas.contains(point)) {
    laserCanvas.handlePressed();
  } 
  else if (commandPanel.contains(point)) {
    commandPanel.handlePressed(point);
  }
}
