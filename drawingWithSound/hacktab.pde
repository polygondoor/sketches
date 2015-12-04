/*
 *  loudness 0-100
 *  pitch 0-255
 */
 
void drawing(float loudness, float pitch){
  
  //     Hue,      Saturation, Value
  stroke(pitch,    2000,       2000);
  
  ellipse(0,0, loudness,loudness);
  
}