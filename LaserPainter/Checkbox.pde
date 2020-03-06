class CheckBox {
  String label;
  int labelTextSize;
  int x,y,w,h;
  boolean currentValue;
  
  public CheckBox(String label, int labelTextSize, int x, int y, int w, int h, boolean currentValue) {
    this.label = label;
    this.labelTextSize = labelTextSize;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.currentValue = currentValue;
  }
  
  void draw() {
    push();
    stroke(0);
    fill(255);
    strokeWeight(1);
    rect(x, y, w, h);
    if(currentValue) {
      stroke(127);
      fill(200);
      ellipse((2*x+w)/2, (2*y+h)/2, w/2, h/2);
    }
    fill(0);
    textSize(labelTextSize);    
    text(label, x, y*0.90);
    pop();
  }
  
  boolean contains(PVector point) {
    return point.x > x && point.x < (x + w) && point.y > y && point.y < (y + h) ;
  }
  
  void handlePressed(PVector point) {
    if(contains(point)) {
      currentValue = !currentValue;
    }
  }
  
  boolean getCurrentValue() {
    return currentValue;
  }
}
