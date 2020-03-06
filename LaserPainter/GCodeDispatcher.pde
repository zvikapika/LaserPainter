import java.io.*;
import javax.swing.JOptionPane;

class GCodeDispatcher implements Runnable {

  CommandPanel commander;
  boolean live;
  String[] INIT_GCODE_COMANDS = {
    "G21", 
    "G90" 
  };

  Serial port;
  List<GCodeCommand> realtimeQueue = Collections.synchronizedList(new ArrayList<GCodeCommand>());
  List<GCodeCommand> replayQueue = Collections.synchronizedList(new ArrayList<GCodeCommand>());

  public GCodeDispatcher(CommandPanel commander, String portName, boolean live) {
    this.live = live;
    if(live) {
      println("available ports: "); 
      println(Serial.list());
      println("Opening serial " + portName);
      port = new Serial(LaserPainter.this, portName, 115200);
      delay(2000);
      while (port.available() > 0) {
        print((char)port.read()); 
        delay(5);
      }
    }
    for (int i = 0; i < INIT_GCODE_COMANDS.length; ++i) {
      sendCommand(INIT_GCODE_COMANDS[i]);
    }
    queueCommand(new LaserSetJogFeedRateCommand(commander.getJogFeedRate()));
    queueCommand(new LaserSetBurnFeedRateCommand(commander.getBurnFeedRate()));
    this.commander = commander;
  }

  public void run() {
    while (true) {
      if (realtimeQueue.size() > 0) {
        GCodeCommand gc = realtimeQueue.remove(0); 
        for(String cmd : gc.asGCode()) {
          sendCommand(cmd);
        }
      }
    }
  }

  boolean sendCommand(String cmd) {
    println("Sending: '"+cmd+"'");
    if (live) {
      cmd += "\n";
      // long sentTimestamp = millis();
      port.write(cmd);
      String reply=null;
      while (reply == null) {
        if (port.readStringUntil('o') != null) {
          while (reply == null) {
            int ret = port.read();
            if (ret > 0) {
              reply = String.valueOf((char)ret);
              //println("reply: '"+reply+"' (took: " +(millis()-sentTimestamp) + ")");

              while (port.available() > 0) {
                // print((char)port.read());
                port.read();
              }
            }
          }
        }
      }
      boolean res = reply.length() > 0 && reply.charAt(0) == 'k';
      return res;
    } 
    else {
      return false;
    }
  }

 void queueCommand(GCodeCommand cmd) {
    realtimeQueue.add(cmd);
    replayQueue.add(cmd);
  }

  //void queueCommand(float x, float y, int power) {
  //  LaserCommand lc = new LaserCommand(x, y, power);
  //  realtimeQueue.add(lc);
  //  replayQueue.add(lc);
  //}

  void clearReplayQueue() {
    replayQueue.clear();
    queueCommand(new LaserSetJogFeedRateCommand(commander.getJogFeedRate()));
    queueCommand(new LaserSetBurnFeedRateCommand(commander.getBurnFeedRate()));
  }

  public void replay() {
    realtimeQueue.addAll(replayQueue);
  }

  public void saveGCode() {
    String fname = (new Date()).toString().replace(':', '-').replace(' ', '_') + ".gcode";
    String path = dataPath(fname);
    println("Saving to: " + path);
    FileWriter fw = null;
    try {
      fw = new FileWriter(path);
      for (GCodeCommand gcode: replayQueue) {
        for(String g : gcode.asGCode()) {
          fw.write(g); 
          fw.write("\n");
        }
      }
      JOptionPane.showMessageDialog(null, "Saved to: " + path);
    }
    catch(IOException ioe) {
      if(fw != null) { 
        try {
          fw.close(); 
        } catch(IOException pesky) {
          JOptionPane.showMessageDialog(null, "error saving to: " + path + ", reason:" + pesky.getMessage());
          pesky.printStackTrace();
      };
      }
    }
  }
}  
