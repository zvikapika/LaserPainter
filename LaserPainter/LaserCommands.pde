interface GCodeCommand {
  public String[] asGCode();
}

class LaserGotoCommand implements GCodeCommand {
  public float x, y;
  public int power;

  LaserGotoCommand(float x, float y, int power) {
    this.x = x;
    this.y = y;
    this.power = power;
  }

  public String[] asGCode() {
    if(power > 0) {
      return new String[] {
        START_LASER + power,
        BURN_COMMAND + " X" + x + " Y" + y,
        STOP_LASER
      };
    }
     else {
        return new String[] {
          JOG_COMMAND + " X" + x + " Y" + y
        };
      }
  }
}

class LaserSetJogFeedRateCommand implements GCodeCommand {
  int feedRate;
  LaserSetJogFeedRateCommand(int feedRate) {
    this.feedRate = feedRate;
  }
  public String[] asGCode() {
    return new String[] { "G0 F" + feedRate };
  }
}

class LaserSetBurnFeedRateCommand implements GCodeCommand {
  int feedRate;
  LaserSetBurnFeedRateCommand(int feedRate) {
    this.feedRate = feedRate;
  }
  public String[] asGCode() {
    return new String[] { "G1 F" + feedRate };
  }
}
