class CommandPanel implements ButtonListener { //<>//
  int x, y, w, h;
  int power = 127;
  Slider powerSlider;
  Slider jogFeedRateSlider;
  Slider burnFeedRateSlider;
  // CheckBox dotCheckbox;
  Button clearButton;
  Button replayButton;
  Button saveButton;

  CommandPanel(int x) {
    this.x = x;
    this.y = 0;
    this.w = width - x;
    this.h = height - y;
    powerSlider =        new Slider("Power", 20, x+20, y+200, 300, 30, 0, 255, 127);
    jogFeedRateSlider =  new Slider("Jog Feed Rate", 20, x+20, y+300, 300, 30, 100, 4000, 3000);
    jogFeedRateSlider.setOnChangeListener(new OnChangeListener() {
      void onChange(Object source, Object oldVal, Object newVal) {
        dispatcher.queueCommand(new LaserSetJogFeedRateCommand(Integer.parseInt(newVal.toString())));
      }
    });
    burnFeedRateSlider = new Slider("Burn Feed Rate", 20, x+20, y+400, 300, 30, 100, 4000, 1000);
    burnFeedRateSlider.setOnChangeListener(new OnChangeListener() {
      void onChange(Object source, Object oldVal, Object newVal) {
        dispatcher.queueCommand(new LaserSetBurnFeedRateCommand(Integer.parseInt(newVal.toString())));
      }
    });

    // dotCheckbox = new CheckBox("Dot", 20, x+20, y+300, 50, 50, true);
    clearButton =  new Button("Clear",   20, x+20, y+500, 80, 50, this);
    replayButton = new Button("Replay",  20, x+120, y+500, 80, 50, this);
    saveButton =   new Button("Save",    20, x+220, y+500, 80, 50, this);
  }

  void draw() {
    push();
    stroke(255);
    fill(255);
    rect(x, y, w, h);
    pop();

    push();
    stroke(0);
    fill(0);
    textSize(48);
    text("Laser Painter", x+ 20, y + 50);
    textSize(12);
    text("by Zvika Markfeld, Studio ExMachina, 2020", x + 20, y + 100);
    pop();

    push();
    stroke(0, 255, 0);
    strokeWeight(BORDER_WEIGHT);
    noFill();
    rect(x, y, w, h);
    pop();

    powerSlider.draw();
    jogFeedRateSlider.draw();
    burnFeedRateSlider.draw();

    // dotCheckbox.draw();
    clearButton.draw();
    replayButton.draw();
    saveButton.draw();
  }

  boolean contains(PVector point) {
    return point.x > x && point.x < (x+w) && point.y > y && point.y < y+h;
  }

  void handle(PVector point) {
    if (powerSlider.contains(point)) {
      powerSlider.handle(point);
    } else if (jogFeedRateSlider.contains(point)) {
      jogFeedRateSlider.handle(point);
    } else if (burnFeedRateSlider.contains(point)) {
      burnFeedRateSlider.handle(point);
    }
  }

  void handlePressed(PVector point) {
    /*
    if (dotCheckbox.contains(point)) {
     dotCheckbox.handlePressed(point);
     }
     */
    if (clearButton.contains(point)) {
      clearButton.handlePressed(point);
    } 
    else if (replayButton.contains(point)) {
      replayButton.handlePressed(point);
    } 
    else if (saveButton.contains(point)) {
      saveButton.handlePressed(point);
    }
  }

  void handleReleased(PVector point) {
  }


  int getPower() {
    return powerSlider.getCurrentValue();
  }

  int getJogFeedRate() {
    return jogFeedRateSlider.getCurrentValue();
  }

  int getBurnFeedRate() {
    return burnFeedRateSlider.getCurrentValue();
  }

  void onPressed(Object source, PVector location) {
    if (source == clearButton) {
      laserCanvas.clear();
      dispatcher.clearReplayQueue();
    } 
    else if (source == replayButton) {
      dispatcher.replay();
    } 
    else if (source == saveButton) {
      dispatcher.saveGCode();
    }
  }
}
