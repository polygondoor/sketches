/**
 * Get Line In
 * by Damien Di Fede.
 * Slight color modification by TfGuy44
 *  
 * This sketch demonstrates how to use the <code>getLineIn</code> method of 
 * <code>Minim</code>. This method returns an <code>AudioInput</code> object. 
 * An <code>AudioInput</code> represents a connection to the computer's current 
 * record source (usually the line-in) and is used to monitor audio coming 
 * from an external source. There are five versions of <code>getLineIn</code>:
 * <pre>
 * getLineIn()
 * getLineIn(int type) 
 * getLineIn(int type, int bufferSize) 
 * getLineIn(int type, int bufferSize, float sampleRate) 
 * getLineIn(int type, int bufferSize, float sampleRate, int bitDepth)  
 * </pre>
 * The value you can use for <code>type</code> is either <code>Minim.MONO</code> 
 * or <code>Minim.STEREO</code>. <code>bufferSize</code> specifies how large 
 * you want the sample buffer to be, <code>sampleRate</code> specifies the 
 * sample rate you want to monitor at, and <code>bitDepth</code> specifies what 
 * bit depth you want to monitor at. <code>type</code> defaults to <code>Minim.STEREO</code>,
 * <code>bufferSize</code> defaults to 1024, <code>sampleRate</code> defaults to 
 * 44100, and <code>bitDepth</code> defaults to 16. If an <code>AudioInput</code> 
 * cannot be created with the properties you request, <code>Minim</code> will report 
 * an error and return <code>null</code>.
 * 
 * When you run your sketch as an applet you will need to sign it in order to get an input. 
 * 
 * Before you exit your sketch make sure you call the <code>close</code> method 
 * of any <code>AudioInput</code>'s you have received from <code>getLineIn</code>.
 */

import ddf.minim.*;

Minim minim;
AudioInput in;
color white;

void setup()
{
  size(1000, 1000, P2D);
  white = color(255);
  colorMode(HSB,100);
  minim = new Minim(this);
  minim.debugOn();
  
  // get a line in from Minim, default bit depth is 16
  in = minim.getLineIn(Minim.STEREO, 512);
  background(white);
}

float angle = 0;
int radius = 200;

float workingAngle = 0;
float volume = 0;
float finalX = 0;
float finalY = 0;

void draw()
{
 angle = angle + 1;
 stroke(0);
 strokeWeight(0.1);
 
 // line(250,250, 250 + (cos(radians(angle)) * radius), 250 + (sin(radians(angle)) * radius));
 
  //background(0);
  stroke(white);
  noFill();
  // draw the waveforms
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    // make a star shape
    workingAngle = angle + (i / 1000);
    volume = in.left.get(i)*600;
    finalX = cos(radians(workingAngle));
    finalY = sin(radians(workingAngle));
    
    stroke((1+in.left.get(i))*255,(1+in.right.get(i))*255,50);
    
    // volume determines line length
    // line(500, 500, 250 + (finalX * volume), 250 + (finalY * volume));
   
    // volume determines circle radius
    ellipse(500 + (finalX * 200), 500 + (finalY * 200), volume, volume);

  }
}

void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  super.stop();
}