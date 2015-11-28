
void draw(){

    plot();

}

void drawing(int x, int y, int scale) {
  
  pushMatrix();
  translate(x,y);
  ellipse(0,0,scale,scale);
  popMatrix();
  
//     for (int i=0;i < 30;i++){
  
//   pushMatrix();
//   translate(width/2, height/2);
//   rotate(radians(20*i));
//   rect(x,y,scale,scale);
//   popMatrix();
// }

}