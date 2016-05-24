#include <AccelStepper.h>
#include <AFMotor.h>

/* START CONFIG */
// Steps for one turn
int stepsForFullRotation = 2048;
// Diameters of wheels
float leftWheelDiameter = 63.6;
float rightWheelDiameter = 64;
// Diameter of turtle (gap between wheels)
float turtleDiameter = 112; 
/* END CONFIG */

// work out travel distances
float leftWheelTravelPerTurn = leftWheelDiameter * 3.1416;
float rightWheelTravelPerTurn = rightWheelDiameter * 3.1416;
float turtleTravelPerTurn = turtleDiameter * 3.1416;

// two stepper motors one on each port
AF_Stepper motor1(stepsForFullRotation, 1);
AF_Stepper motor2(stepsForFullRotation, 2);

// The below lines are used to wrap AF_Motor into AccelStepper
// You can change these to DOUBLE or INTERLEAVE or MICROSTEP
void forwardstep1()  { motor1.onestep(FORWARD, DOUBLE);  }
void backwardstep1() { motor1.onestep(BACKWARD, DOUBLE); }
void forwardstep2()  { motor2.onestep(FORWARD, DOUBLE);  }
void backwardstep2() { motor2.onestep(BACKWARD, DOUBLE); }
// Motor shield has two motor ports, now we'll wrap them in an AccelStepper object
AccelStepper stepper1(forwardstep1, backwardstep1);
AccelStepper stepper2(backwardstep2, forwardstep2);

void setup()
{  
    Serial.begin(9600);

    // Set up the maximum speed of each stepper
    stepper1.setMaxSpeed(1000);
    stepper2.setMaxSpeed(1000);
}

int leafCount = 0;
int currentStep = 0;
int maxStep;

int leftRounds = 0;
int rightRounds = 0;

void loop()
{
    // Wait for both wheels to stop before going to next step
    if ( (stepper1.distanceToGo() == 0) && (stepper2.distanceToGo() == 0) ) {

      if (leafCount == 100) {
        
      } else {
        switch (currentStep) {
          
          case 0: goFowards(60); break;
          case 1: pivotLeft(90); break;
          case 2: goFowards(20); break;
          case 3: pivotLeft(108.4); break;
          case 4: goFowards(63.25); break;
          case 5: pivotRight(161); break;
          case 6: 
            currentStep = -1;
            leafCount ++;
            break;
        }
      }
      currentStep++;
    }

    stepper1.runSpeedToPosition();
    stepper2.runSpeedToPosition();    
}

int leftPosition = 0;
int leftSpeed = 0;
int rightPosition = 0;
int rightSpeed = 0;

// to do a quarter turn, wheel has to travel 1/4 of turtle diameter
// travel = 0.25 * turtleDiameter * 3.1416
// for wheel to tarvel that far, it has to turn how many times?
// oneTurn = leftWheelDiameter * 3.1416   
// How man turns of small wheel = travel / oneTurn
// at 2048 steps per turn, thats travel/oneTurn * 2048

float leftStepsToTurn(float deg) {
  //      distance travelled by the wheel    /   how many turns of small wheel  * steps per rotation
  return (turtleTravelPerTurn * (deg / 360)) / leftWheelTravelPerTurn           *    stepsForFullRotation;
}

float rightStepsToTurn(float deg) {
  //      distance travelled by the wheel    /   how many turns of small wheel  * steps per rotation
  return (turtleTravelPerTurn * (deg / 360)) / rightWheelTravelPerTurn           *    stepsForFullRotation;
}

float leftDistanceToSteps(float mm){
  return mm / leftWheelTravelPerTurn * stepsForFullRotation;
}

float rightDistanceToSteps(float mm){
  return mm / rightWheelTravelPerTurn * stepsForFullRotation;
}

void pivotLeft(float deg) {  
  
  //      distance travelled by the wheel    /   how many turns of small wheel  * steps per turn
  leftPosition  = leftStepsToTurn(deg);
  rightPosition = rightStepsToTurn(deg);
  
  stepper2.move( leftPosition );
  stepper2.setSpeed( -400 );
  stepper1.move( rightPosition );
  stepper1.setSpeed( 400 );
}

void pivotRight(float deg) {

  //      distance travelled by the wheel    /   how many turns of small wheel  * steps per turn
  leftPosition  = leftStepsToTurn(deg);
  rightPosition = rightStepsToTurn(deg);
  
  stepper2.move( leftPosition );
  stepper2.setSpeed( 400 );
  stepper1.move( rightPosition );
  stepper1.setSpeed( -400 );
}

void goFowards(float mm) {

  leftPosition  = leftDistanceToSteps(mm);
  rightPosition = rightDistanceToSteps(mm);
  
  stepper1.move( leftPosition );
  stepper1.setSpeed( 400 );
  stepper2.move( rightPosition );
  stepper2.setSpeed( 400 );
}

void goBackwards(float mm) {

  leftPosition  = leftDistanceToSteps(mm);
  rightPosition = rightDistanceToSteps(mm);
  
  stepper1.move( leftPosition );
  stepper1.setSpeed( -400 );
  stepper2.move( rightPosition );
  stepper2.setSpeed( -400 );
}
