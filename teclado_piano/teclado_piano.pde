import java.util.Arrays;
import javax.sound.midi.*;

public class MusicBox {
  Synthesizer synthesizer;
  MidiChannel[] channels;
  boolean noSound = false;

  public void initialize() {
    try {
      if (!noSound) {
        synthesizer = MidiSystem.getSynthesizer();
        synthesizer.open();

        channels = synthesizer.getChannels();

        Instrument[] instr = synthesizer.getDefaultSoundbank()
          .getInstruments();
        synthesizer.loadInstrument(instr[0]);
        System.out.println(channels.length);
      }
    }
    catch (Exception ex) {
      System.out.println("Could not load the MIDI synthesizer.");
    }
  }

  public void cleanUp() {
    if (synthesizer != null)
      synthesizer.close();
  }

  public void playNote(final int note, final int milliseconds) {
    System.out.println("");

    Thread t = new Thread() {
      public void run() {
        try {
          if (!noSound && channels != null && channels.length > 0) {
            channels[0].noteOn(note, 120);
            sleep(milliseconds);
            channels[0].noteOff(note);
          }
        } 
        catch (Exception ex) {
          System.out.println("ERROR: " + ex);
        }
      }
    };
    t.start();
  }

  public void playChord(int note1, int note2, int note3, int milliseconds) {
    playChord(new int[] {note1, note2, note3}, milliseconds);
  }

  public void playChord(final int[] notes, final int milliseconds) {
    System.out.println("");

    Thread t = new Thread() {
      public void run() {
        try {
          if (!noSound && channels != null && channels.length > 0) {
            int channel = 0;
            for (int n : notes) {
              channels[channel++].noteOn(n, 120);
            }
            sleep(milliseconds);
            for (channel = 0; channel < notes.length; channel++) {
              channels[channel].noteOff(notes[channel]);
            }
          }
        }
        catch (Exception ex) {
          System.out.println("ERROR:" + ex);
        }
      }
    };
    t.start();
  }

  public void playScale(int note1, int note2, int note3, int note4, int note5, 
    int note6, int note7, int note8, int milliseconds) {
    playScale(new int[] {note1, note2, note3, note4, note5, note6, note7, note8}, milliseconds);
  }

  public void playScale(final int[] notes, final int milliseconds) {
    Thread t = new Thread() {
      public void run() {
        try {
          if (!noSound && channels != null && channels.length > 0) {
            for (int n : notes) {
              channels[0].noteOn(n, 120);
              sleep(milliseconds);
              channels[0].noteOff(n);
            }
          }
        }
        catch (Exception ex) {
          System.out.println("ERROR:" + ex);
        }
      }
    };
    t.start();
  }

  private void sleep(int length) {
    try {
      Thread.sleep(length);
    }
    catch (Exception ex) {
    }
  }
}

MusicBox mb;
boolean blackPressed = false;
void setup() {
  size(800, 600);
  background(255);
  mb = new MusicBox();
  mb.initialize();
}
void draw() {
  //declaring variables that will make it easier to adjust
  //the parameters as to how to draw the piano.
  int keyWidth= 0;
  int whiteWidth= width/8;
  float blackHeight= height*3/5;
  float blackWidth= whiteWidth/2;
  // Variable for if mouse is over black or white keys
  int blackHover= -1;
  //Without the following code, when the mouse "hovers" over a key, 
  // then the white and black keys will be colored at the same time. 
  // This code singles out each key to change color individually.
  for (int i=0; i<8; i++) {
    float keyHeight= whiteWidth*(i+1)- blackWidth/2;
    if (mouseX> keyHeight && mouseX <= keyHeight+blackWidth && 
      mouseY <= blackHeight && i !=2 && i != 6) {
      blackHover = i;
    }
  }
  // Draws the white keys.
  for ( int whiteKey=0; whiteKey < width/whiteWidth; whiteKey++) {
    stroke(1);
    blackHover= whiteKey;
    int keyHeight = whiteKey * whiteWidth;
    // When you press the mouse, the White key will change color.
    if (mouseX >= keyHeight && mouseX <= keyHeight+ whiteWidth && mouseY<= whiteWidth + (keyHeight + 500) && !blackPressed && mousePressed && blackHover == whiteKey) {
      fill(155, 250, 200);
      mb.playNote(whiteKey+60, 1000);
      // When the mouse hovers over the key, the white key will be gray.
    } else if ( mouseX >= keyHeight && mouseX <=keyHeight + whiteWidth && blackHover == -1) {
      fill(150, 155, 150);
      //if none of the parameters are true, then the keys remain white.
    } else {
      fill(255);
    }
    rect(keyHeight, keyWidth, whiteWidth, height);
  }
  // Draws the black keys and makes sure there is only 5 keys
  for (int blackKey=0; blackKey<6; blackKey++) {
    noStroke();
    float keyHeight= whiteWidth*(blackKey+1)- blackWidth/2;
    if (blackKey==2) {
      keyHeight= whiteWidth*(blackKey+1)-blackWidth/2+whiteWidth;
    }
    fill(0);
    blackHover= blackKey;
    if (mouseX >= keyHeight && mouseX <= keyHeight+blackWidth && mouseY<= blackHeight && mousePressed &&blackHover== blackKey) {
      stroke(2);
      blackPressed = true;
      fill(0, 255, 255);
      mb.playNote(blackKey+60, 1000);
      // When the mouse hovers, the black key turns gray.
    } else if (mouseX>keyHeight&& mouseX<= keyHeight+ blackWidth&& mouseY <= blackHeight &&  blackHover== blackKey) {
      stroke(1);
      blackPressed = false;
      fill(150, 155, 150);
    } else {
      fill(0);
    }
    rect(keyHeight, keyWidth, blackWidth, blackHeight);
  }
}
