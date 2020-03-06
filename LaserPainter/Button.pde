interface ButtonListener {
  void onPressed(Object source, PVector location);
}

class Button {
  String label;
  int labelTextSize;
  int x,y,w,h;
  ButtonListener listener;
  
  public Button(String label, int labelTextSize, int x, int y, int w, int h, ButtonListener listener) {
    this.label = label;
    this.labelTextSize = labelTextSize;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.listener = listener;
  }
  
  void draw() {
    push();
    stroke(0);
    fill(127);
    strokeWeight(2);
    rect(x, y, w, h);
    fill(0);
    textSize(labelTextSize);
    int labelWidth = (int)textWidth(label);
    text(label, x + (w-labelWidth)/2, y + labelTextSize + (h-labelTextSize)/2);
    pop();
  }
  
  boolean contains(PVector point) {
    return point.x > x && point.x < (x + w) && point.y > y && point.y < (y + h) ;
  }
  
  void handlePressed(PVector point) {
    if(contains(point)) {
      listener.onPressed(this, point);
    }
  }
}
