class Slider {
  String label;
  int labelTextSize;
  int x,y,w,h;
  int minValue, maxValue;
  int buttonRadius;
  int currentValue;
  int buttonPosition;
  OnChangeListener listener;
  
  public Slider(String label, int labelTextSize, int x, int y, int w, int h, int minValue, int maxValue, int currentValue) {
    this.label = label;
    this.labelTextSize = labelTextSize;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.minValue = minValue;
    this.maxValue = maxValue;
    this.currentValue = currentValue;
    buttonRadius = h/2;
    buttonPosition = (int)map(currentValue, minValue, maxValue, x, x+w);
  }

  void draw() {
    push();
    stroke(0);
    fill(255);
    strokeWeight(1);
    rect(x, y, w, h);
    line(x, (2*y+h)/2, x + w, (2*y+h)/2);
    stroke(127);
    fill(200);
    ellipse(buttonPosition, (2*y+h)/2, buttonRadius, buttonRadius);
    fill(0);
    textSize(labelTextSize);    
    text(label + ": " + currentValue, x, y*0.90);
    pop();
  }
  
  boolean contains(PVector point) {
    return point.x > x && point.x < (x + w) && point.y > y && point.y < (y + h) ;
  }
  
  void handle(PVector point) {
    if(contains(point)) {
      buttonPosition = (int)point.x;
      int newValue = (int)map(buttonPosition, x, x+w, minValue, maxValue);
      if(newValue != currentValue) {
        if(listener != null) {
          listener.onChange(this, currentValue, newValue);
        }
        currentValue = newValue;
      }
    }
  }
  
  int getCurrentValue() {
    return currentValue;
  }
  
  void setOnChangeListener(OnChangeListener l) {
    this.listener = l;
  }
}
