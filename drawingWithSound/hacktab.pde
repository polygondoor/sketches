
void draw(){

  
  
  
  
plot();

}

void drawing(int x, int y, int scale,float angle) {
  
  pushMatrix();
  translate(x,y); 
  rotate(radians(angle));
  scale(scale);
  //println(scale);
  
  //paste your drawing code here
  
  noFill();
  strokeWeight(.1);
  
  ////color green = color(0,170,0);
  ////color red = color(200,0,0);
  ////color blue = color(0,0,150);
  ////stroke(green);
  ////body
  //rect(40,60,60,60);
  ////arms green
  //rect(10,90,30,10);
  //rect(100,90,30,10);
  //// legs green
  //rect(40,120,10,10);
  //rect(90,120,10,10);
  ////legs blue
 //// stroke(blue);
  //rect(30,130,10,10);
  //rect(100,130,10,10);
  ////legs blue
 //// stroke(red);
  //rect(20,140,20,10);
  //rect(100,140,20,10);
  // //arms blue
 //// stroke(blue);
  //rect(0,80,30,10);
  //rect(110,80,30,10);
  ////arms red
  ////stroke(red);
  //rect(0,70,30,10);
  //rect(110,70,30,10);
  ////eyes
  //rect(50,70,10,10);
  //rect(60,80,20,10);
  //rect(80,70,10,10);
  ////mouth
  ////stroke(0);
  //rect(50,90,40,20);
  ////antenna
 //// stroke(blue);
  //line(60,60,40,20);
  //line(80,60,100,20);
  ////stroke(blue);
  //ellipse(35,10,20,20);
  //ellipse(100,10,20,20);
  
  
//body
rect(40,30,50,60);
// face
rect(50,40,10,10);
rect(70,40,10,10) ;
rect (55,45,5,5);
rect (70,45,5,5);
line (60,60,60,65);
line (60,65,70,65);
line (70,65,70,70);
line (50,80,80,80);
line (50,75,50,85);
//antenna
rect (40,10,5,20);
rect (85,10,5,20);

// right arm

rect (20,50,20,10);
rect (10,60,10,10);
rect (20,70,20,10);

// left arm

rect (90,50,20,10);
rect (110,60,10,10);
rect (90,70,20,10);

//legs

rect (50,90,10,30);
rect (70,90,10,30);

//SHOES

rect (40,120,20,10);
rect (70,120,20,10);
  
  
  //paste your drawing code above here
  
  
  
  
  
  
  scale(0);
  popMatrix();
  


}