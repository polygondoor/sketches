import processing.pdf.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
color white;
FFT fft;

float [] max= new float [44100/2];//array that contains the half of the sampleRate size, because FFT only reads the half of the sampleRate frequency. This array will be filled with amplitude values.
float maximum;//the maximum amplitude of the max array
float frequency;//the frequency in hertz

void setup()
{
  //size(3508,2480);
  size(595,842);
  white = color(255);
  background(white);
  drawPolydonDoorLogo(260,740,0.6);
  
  colorMode(HSB,2000);
  
  minim = new Minim(this);
  radius = (int)(width/3.75);

  in = minim.getLineIn(Minim.MONO, 256);
  //background(white);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  
  // Uncomment this to try the PDF recording 
  // also uncomment the "endRecord" line at end of draw method
  // beginRecord(PDF, "polygondoor_drew_with_sound.pdf"); 
  
}

boolean shouldContinue = true;

float angle = 0;

float workingAngle = 0;
float volume = 0;
float finalX = 0;
float finalY = 0;
float rangeUp = 1000;
float sizeSteps = 1;
float prevX;
float prevY;
int radius;

void plot()
{
 // println(radius);

if (angle <= 360){
  

  angle = angle + sizeSteps;


  noFill();
  
  fft.forward(in.mix);
  float samplerate = in.sampleRate();

 
  
  for (int f=0;f<samplerate/2;f++) { //analyses the amplitude of each frequency analysed, between 0 and 22050 hertz
  
   
    max[f]=fft.getFreq(float(f)); //each index is correspondent to a frequency and contains the amplitude value 
  }
  
  maximum=max(max);//get the maximum value of the max array in order to find the peak of volume
  
 
  for (int i=0; i<max.length; i++) {// read each frequency in order to compare with the peak of volume
    if (max[i] == maximum) {//if the value is equal to the amplitude of the peak, get the index of the array, which corresponds to the frequency
      frequency= i;
    }
  }
  

  
  
  // draw the waveforms
  for(int i = 0; i < in.bufferSize() - 1; i++)
  {
    
    pushMatrix();
    translate(width/2, height/2);
    rotate(radians(angle));  
    line( radius, radius, radius + in.left.get(i+1)*500, radius + in.left.get(i+1)*500);
    popMatrix();
    
    
    // make a star shape
    workingAngle = angle /* + (i / 1000)*/;
    volume = in.left.get(i)*rangeUp;
    finalX = cos(radians(workingAngle));
    finalY = sin(radians(workingAngle));
    
    //stroke((1+in.left.get(i))*255,(1+in.right.get(i))*255,random(255),50);
    //println(frequency);  //work out good frequency spectrum
    if (frequency > 200 && frequency < 15000){

     
    //println(frequency);
    stroke(frequency,frequency,frequency,80);
    }
    
    strokeWeight(1);
    
    // volume determines line length
    // line(500, 500, 250 + (finalX * volume), 250 + (finalY * volume));
   
    // volume determines circle radius
 //  ellipse(width/2 + (finalX * radius), (height/2) + (finalY * radius), volume, volume);
 
   drawing((int)(width/2 + (finalX * radius)), (int)((height/2) + (finalY * radius)),(int)volume);
  }
} else {
  noLoop();
  
  // get timestamp to save file
  java.util.Date d = new java.util.Date();
  long current = d.getTime()/1000; 

  // uncomment this to try the PDF recording.
  //endRecord();
  
  // uncomment this to try the PNG saving
  saveFrame("polygondoor_drew_with_sound_" + current + "_.png");
}
}
    
void drawPolydonDoorLogo(int x, int y, float scale){
  colorMode(RGB);
  noStroke();
  fill(230, 1, 52);
  beginShape();
  vertex(x + (20 * scale), y + (6 * scale));
  vertex(x + (98 * scale), y +  (12 * scale));
  vertex(x + (58 * scale), y +  (92 * scale));
  vertex(x + (6 * scale), y + (44 * scale));
  endShape(CLOSE);
  
  fill(131, 20, 52);
  beginShape();
  vertex(x + (98 * scale), y + (12 * scale));
  vertex(x + (58 * scale), y + (92 * scale));
  vertex(x + (58 * scale), y + (32 * scale));
  endShape(CLOSE);
}
  
void stop()
{
  // always close Minim audio classes when you are done with them
  in.close();
  minim.stop();
  super.stop();
}