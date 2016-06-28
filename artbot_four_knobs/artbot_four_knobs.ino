
#include <Adafruit_GFX.h>   // these things at the top just load a bunch of libraries we need to run the screen.
#include <SPI.h>            // libraries are collections of code that have been written by others so we don't
#include <Wire.h>           // don't have to.
#include <Adafruit_SSD1306.h>  //we need these for libraries to make our screen easier to use.
#define OLED_RESET 4                  // this code resets the display.
Adafruit_SSD1306 display(OLED_RESET);  //

#include <AccelStepper.h>
#include <AFMotor.h>

// two stepper motors one on each port
AF_Stepper motor1(2048, 1);
AF_Stepper motor2(2048, 2);

// you can change these to DOUBLE or INTERLEAVE or MICROSTEP!
// wrappers for the first motor!
void forwardstep1() {
  motor1.onestep(FORWARD, SINGLE);
}
void backwardstep1() {
  motor1.onestep(BACKWARD, SINGLE);
}
// wrappers for the second motor!
void forwardstep2() {
  motor2.onestep(BACKWARD, SINGLE);
}
void backwardstep2() {
  motor2.onestep(FORWARD, SINGLE);
}

// Motor shield has two motor ports, now we'll wrap them in an AccelStepper object
AccelStepper stepper1(forwardstep1, backwardstep1);
AccelStepper stepper2(forwardstep2, backwardstep2);

float maxSpeedLeft = 400;
float accelerationLeft = 100;
float moveToLeft = 10000;

float maxSpeedRight = 400;
float accelerationRight = 100;
float moveToRight = 1000000;

int pinA_1 = 34;
int pinB_1 = 32;
int pinButton_1 = 30;
int val_1;
int val_1b;
long encoderPosCount_1 = 93; // distance
int pinALast_1;
boolean bCW_1;

int pinA_2 = 40;
int pinB_2 = 38;
int pinButton_2 = 36;
int val_2;
int val_2b;
long encoderPosCount_2 = 25; // speed
int pinALast_2;
boolean bCW_2;

int pinA_3 = 46;
int pinB_3 = 44;
int pinButton_3 = 42;
int val_3;
int val_3b;
long encoderPosCount_3 = 35; // speed (30)
int pinALast_3;
boolean bCW_3;

int pinA_4 = 52;
int pinB_4 = 50;
int pinButton_4 = 48;
int val_4;
int val_4b;
long encoderPosCount_4 = 99999; // distance (1000)
int pinALast_4;
boolean bCW_4;

int increment = 10;

boolean isDrawing = false;

void setup()
{
  pinMode(pinA_1, INPUT); // clk
  pinMode(pinB_1, INPUT); // dt
  pinMode(pinButton_1, INPUT);

  pinMode(pinA_2, INPUT); // clk
  pinMode(pinB_2, INPUT); // dt
  pinMode(pinButton_2, INPUT);

  pinMode(pinA_3, INPUT); // clk
  pinMode(pinB_3, INPUT); // dt
  pinMode(pinButton_3, INPUT);

  pinMode(pinA_4, INPUT); // clk
  pinMode(pinB_4, INPUT); // dt
  pinMode(pinButton_4, INPUT);

  pinALast_1 = digitalRead(pinA_1);
  pinALast_2 = digitalRead(pinA_2);
  pinALast_3 = digitalRead(pinA_3);
  pinALast_4 = digitalRead(pinA_4);

  // dispay config
  display.begin(SSD1306_SWITCHCAPVCC, 0x3C); // its the 0x3C that says "128 * 64"

  display.clearDisplay();
  display.setTextColor(WHITE);
  /*
    display.setTextSize(1);
    display.setCursor(10, 0); // this moves our cursor right back to the top left pixel.. we should talk about this.
    display.print("The Polygon Door"); //this copies some text to the screens memory
  */
  display.setTextSize(3);
  display.setCursor(10, 10); // this moves our cursor right back to the top left pixel.. we should talk about this.
  display.print("ARTBOT"); //this copies some text to the screens memory
  display.setTextSize(2);
  display.setCursor(20, 45);
  display.print("Hello :)"); //this copies some text to the screens memory
  display.display();

  display.setTextSize(3);

  // wait to see the above message
  delay(1000);
}

long steps = 0;

void stopAndResetSteppers() {
  // stop everything
  stepper1.stop(); // Stop as fast as possible: sets new target
  stepper1.runToPosition();
  stepper2.stop(); // Stop as fast as possible: sets new target
  stepper2.runToPosition();

  // reset the steppers to position 0
  stepper1.setCurrentPosition(0);
  stepper2.setCurrentPosition(0);

  // tell the system that we are no longer drawing
  isDrawing = false;
}

void captureSettings() {
  // each wheel is 64mm
  // so if I make the the knob think in mm, then
  // 1 turn is 201.06mm (64 * 3.1416)
  // So, if someone says 100mm, then how many turns is that?
  // turns = configuredDistance / (64 * 3.1416)
  // given that 1 turn is 2048 steps then
  // turns in steps = 2048 * configuredDistance / (64 * 3.1416)

  // RIGHT WHEEL (knobs 1 and 2 (speed))
  stepper1.setMaxSpeed( encoderPosCount_2 * 10); // max 400
  stepper1.setAcceleration(accelerationRight);
  // calculate how many steps to go (here we divide by 2 because the bounce goes fowards and backwards)
  steps = (encoderPosCount_1 * 2048 / (64 * 3.1416) / 2);
  stepper1.moveTo(steps);
  // message( String(steps) );

  // LEFT WHEEL (knobs 4 and 3(speed))
  stepper2.setMaxSpeed( encoderPosCount_3 * 10); // max 400
  stepper2.setAcceleration(accelerationLeft);
  steps = (encoderPosCount_4 * 2048 / (64 * 3.1416) / 2);
  stepper2.moveTo(steps);
}

void loop()
{
  if (!isDrawing) {
    readRotaryEncoders();
    if (digitalRead(pinButton_4) == LOW) {
      // change increment amount
      if (increment == 1) {
        increment = 10;
        message("increment: 10");
      } else if (increment == 10) {
        increment = 100;
        message("increment: 100");
      } else if (increment == 100) {
        increment = 1000;
        message("increment: 1000");
      } else if (increment == 1000) {
        increment = 1;
        message("increment: 1");
      }

      delay(500);
      report();
    }
    if (digitalRead(pinButton_3) == LOW) {
      // reset to defaults
      encoderPosCount_4 = 140;
      encoderPosCount_1 = 100;
      encoderPosCount_2 = 12;
      encoderPosCount_3 = 35;
      report();
      delay(500);
    }
    if (digitalRead(pinButton_1) == LOW) {
      // Start drawing
      isDrawing = true;
      displayStartMessage();
      captureSettings();
    }
  } else {
    if (stepper1.distanceToGo() == 0) {
      // this line resets the whole device (but user needs to wait till wheel bounces)
      if (digitalRead(pinButton_2) == LOW) {
        // stop and reset
        stopAndResetSteppers();
        report();
      }
      stepper1.moveTo(-stepper1.currentPosition());
    }
    if (stepper2.distanceToGo() == 0) {
      stepper2.moveTo(-stepper2.currentPosition());
    }
    stepper1.run();
    stepper2.run();
  }
}

void readRotaryEncoders() {
  val_1 = digitalRead(pinA_1); // orange cable, CLK
  val_1b = digitalRead(pinB_1);

  val_2 = digitalRead(pinA_2);
  val_2b = digitalRead(pinB_2);

  val_3 = digitalRead(pinA_3);
  val_3b = digitalRead(pinB_3);

  val_4 = digitalRead(pinA_4);
  val_4b = digitalRead(pinB_4);

  if ((val_1 != pinALast_1) && (val_1 == LOW)) { // Knob Rotated l when aVal changes, BUT use only if aVal is LOW.
    if (val_1b == LOW) {
      encoderPosCount_1 += increment; //
      report();
    } else {
      encoderPosCount_1 -= increment;
      report();
    }
  }
  pinALast_1 = val_1; // Don’t forget this

  if ((val_2 != pinALast_2) && (val_2 == LOW)) { // Knob Rotated l when aVal changes, BUT use only if aVal is LOW.
    if (val_2b == LOW) {
      if (encoderPosCount_2 < 40) encoderPosCount_2++; //
      report();
    } else {
      if (encoderPosCount_2 > -40) encoderPosCount_2--;
      report();
    }
  }
  pinALast_2 = val_2; // Don’t forget this

  if ((val_3 != pinALast_3) && (val_3 == LOW)) { // Knob Rotated l when aVal changes, BUT use only if aVal is LOW.
    if (val_3b == LOW) {
      if (encoderPosCount_3 < 40) encoderPosCount_3++; //
      report();
    } else {
      if (encoderPosCount_3 > -40) encoderPosCount_3--;
      report();
    }
  }
  pinALast_3 = val_3; // Don’t forget this

  if ((val_4 != pinALast_4) && (val_4 == LOW)) { // Knob Rotated l when aVal changes, BUT use only if aVal is LOW.
    if (val_4b == LOW) {
      encoderPosCount_4 += increment; //
      report();
    } else {
      encoderPosCount_4 -= increment;
      report();
    }
  }
  pinALast_4 = val_4; // Don’t forget this
}

void report() {
  display.clearDisplay();

  display.setTextSize(1);
  display.setCursor(30 , 0);
  display.print("Speed: 0-40");
  display.setCursor(25 , 36);
  display.print("Distance: mm");

  display.setTextSize(2);
  display.setCursor(70, 50);
  display.print(encoderPosCount_1); //this copies some text to the screens memory

  display.setCursor(70, 12);
  display.print(encoderPosCount_2); //this copies some text to the screens memory

  display.setCursor(0, 12);
  display.print(encoderPosCount_3); //this copies some text to the screens memory

  display.setCursor(0, 50);
  display.print(encoderPosCount_4); //this copies some text to the screens memory

  display.display();
}

void message(String text) {
  display.clearDisplay();
  display.setTextSize(1);
  display.setCursor(20, 40);
  display.print(text); //this copies some text to the screens memory
  display.display();
}

void message(int text) {
  display.clearDisplay();
  display.setTextSize(1);
  display.setCursor(20, 40);
  display.print(text); //this copies some text to the screens memory
  display.display();
}

void displayStartMessage() {

  displayCountDown(3);
  delay(1000);
  displayCountDown(2);
  delay(1000);
  displayCountDown(1);
  delay(1000);

  display.clearDisplay();
  display.setTextSize(4);
  display.setCursor(40, 20);
  display.print("(:"); //this copies some text to the screens memory

  display.setTextSize(1);
  display.setCursor(0, 0);
  display.print(encoderPosCount_3); //this copies some text to the screens memory

  display.setCursor(110, 0);
  display.print(encoderPosCount_2); //this copies some text to the screens memory

  display.setCursor(0, 50);
  display.print(encoderPosCount_4); //this copies some text to the screens memory

  display.setCursor(110, 50);
  display.print(encoderPosCount_1); //this copies some text to the screens memory

  display.display();
}

void displayCountDown(int count) {
  display.clearDisplay();
  display.setTextSize(2);
  display.setCursor(10 , 5);
  display.print("STEP BACK");

  display.setTextSize(1);
  display.setCursor(10 , 40);
  display.print("Starting in: "); //this copies some text to the screens memory

  display.setTextSize(4);
  display.setCursor(94 , 30);
  display.print(count); //this copies some text to the screens memory
  display.display();
}

