/*
 *  loudness 0-200
 *  pitch 0-2000
 */
 
int count = 0;

void drawing(float loudness, float pitch){
  
  if (count++ %20 == 0) {
    
    //     Hue,      Saturation, Value
    stroke(pitch,    2000,       2000);
    ellipse(0,0, loudness,loudness);
    
  }
  
}