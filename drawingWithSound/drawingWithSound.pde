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

PFont font;
int scale;

void setup()
{

  size(595,842);
 // size(1190,1684);
  
  if (width == 595){
   
    scale = 1;
    
  }
  
   if (width == 1190){
   
    scale = 2;
    
  }
  
  white = color(255);
  background(white);
  drawPolydonDoorLogo(width-290*scale,height-60*scale, 0.5*scale);
  font = loadFont("TTProstoSans-60.vlw");
  
  fill(0);  
  textFont(font, 30*scale);
  text("Polygon Door",width-230*scale, height-25*scale);
  
  pushMatrix();
  float logoScale = 1.8;
  translate(width/2-(logoScale*55*scale),height/2.5-(logoScale*40*scale));
  drawPolydonDoorLogo(0,0,logoScale*scale);
  popMatrix();
  
  
  
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
float volume;
float finalX = 0;
float finalY = 0;
float sizeSteps = 1;
float prevX;
float prevY;
int radius;

void plot()
{
  
  colorMode(HSB,2000);
 // println(radius);

if (angle <= 361){
  

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
    
    if (frequency > 200 && frequency < 15000){

     
    //println(frequency);
    stroke(frequency,frequency,frequency,180);
    }
    
    strokeWeight(width/500);
    
    
    pushMatrix();
    translate(width/2, height/2.5);
    rotate(radians(angle));  
    line( radius, radius, radius + in.left.get(i+1)*width, radius + in.left.get(i+1)*width);
    popMatrix();
    
    
    // make a star shape
    workingAngle = angle /* + (i / 1000)*/;
    volume = (in.left.get(i+1)*width);
    finalX = cos(radians(workingAngle));
    finalY = sin(radians(workingAngle));
   
  // println(volume);
   
   // draw students drawing if volume is over threshold
   if ( angle%15 == 0 ){

   drawing((int)(width/2 + (finalX * radius)), (int)((height/2.5) + (finalY * radius)),(int)log(volume),angle);

   }
}
} else {
  
  
  
  noLoop();
  
  
  // get timestamp to save file
  java.util.Date d = new java.util.Date();
  long current = d.getTime()/1000; 

 //  uncomment this to try the PDF recording.
 // endRecord();
  
  //uncomment this to try the PNG saving
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