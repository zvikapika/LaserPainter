class LaserCanvas {
  int x, y, w, h;
  float prevx = -1, prevy = -1;
  GCodeDispatcher dispatcher;
  CommandPanel commander;

  public LaserCanvas(int x, int y, int w, int h, GCodeDispatcher dispatcher, CommandPanel commander) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.dispatcher = dispatcher;
    this.commander = commander;
  }

  void draw() {
    push();
    stroke(255, 0, 0);
    strokeWeight(BORDER_WEIGHT);  
    noFill();
    rect(x, y, w, h);
    pop();
  }

  boolean contains(PVector point) {
    return point.x > x && point.x < (x+w) && point.y > y && point.y < (y + h);
  }

  void handle(PVector point) {
    if (point.x != prevx || point.y != prevy) {
      push();
      stroke(commander.getPower(), 0, 0);
      strokeWeight(1);
      boolean ispoint = true;
      if (prevx < 0) {
        point(point.x, point.y);
      }
      else {
        ispoint = false;
        line(prevx, prevy, point.x, point.y);
      }
      pop();
      float gotoX = map(point.x, 0, CANVAS_WIDTH, LASER_ORIGIN_X, LASER_ORIGIN_X + LASER_WIDTH);
      float gotoY = map(point.y, 0, CANVAS_HEIGHT, LASER_ORIGIN_Y, LASER_ORIGIN_Y + LASER_HEIGHT);
      if (point.x > 0 && point.y > 0) {
          dispatcher.queueCommand(new LaserGotoCommand(gotoX, gotoY, ispoint? 0 : commander.getPower()));
      }
      prevx = point.x; 
      prevy = point.y;
    }
  }

  void handlePressed() {
    prevx = -1; 
    prevy = -1;
  }

  void handleReleased() {
  }

  void clear() {
    push();
    stroke(255);
    fill(255);
    rect(0, 0, w, h);
    pop();
  }
}
