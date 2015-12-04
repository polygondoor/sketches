/*
 *  loudness 0-200
 *  pitch 0-2000
 *  pulse is 0 - 100
 *
 * NOTE: remember to make sure that the right USB port is being used (for pulse sensor)
 */
 
int count = 0;

void drawing(float loudness, float pitch, float pulse){
  
  if (count++ %10 == 0) {
    
    //     Hue,      Saturation, Value
    stroke(pitch,    2000,       2000);
    ellipse(0,0, loudness,loudness);
   
    // line (0,0, pulse, 0);
    
  }
  
}