/*
 *  loudness 0-255
 *  pitch 0-255
 *
 *  NOTE: remember to make sure that the right USB port is being used (for pulse sensor)
 *
 */
 
int count = 0;

void drawing(float loudness, float pitch){
  
  if (count++ %40 == 0) {
    
    // Instead of using the RGB colour mode, 
    // use the HSB one
    colorMode(HSB, 255);
    
    // This fill colour is very see-through
    //  HSB:  Hue,    Saturation, Brightness  (the last number is transparency)
    fill(     pitch,  255,        255,        10);
    noStroke(); // turn off drawing the ellipse outline
    
    // draw the ellipse... its size is driven by loudness
    ellipse (0, 0, loudness/5, loudness/5);
    
    // All the code below this draws a polygon of hue 50
    
    // try changing the scale according to loudness
    // ANything below this line gets drawn with this scale change
    scale(loudness/20);
    
    // Now change the colour of lines
    //     Hue,      Saturation, Brightness
    stroke(50,    255,        pitch, 30);
    noFill();  // dont fill the shapes with colour
    
    // draw a polygon
    beginShape();
    vertex(10, 2);
    vertex(23, 8);
    vertex(2, 9);
    vertex(17, 20);
    vertex(12, 16);
    endShape(CLOSE);
    
  }
  
}