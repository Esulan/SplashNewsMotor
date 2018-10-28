#include <Servo.h>
 
char inBytes[3];

int servoPin1 = 6;
Servo servo1;
 
void setup() {
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  digitalWrite(9, LOW); 
  digitalWrite(10, LOW);
  
  pinMode(6, OUTPUT);     
  digitalWrite(6, LOW);
  
  servo1.attach(servoPin1);
  
  Serial.begin(9600); // opens serial port, sets data rate to 9600 bps
  establishContact();  // send a byte to establish contact until receiver responds 
}

void loop() {
  // when you receive data:
  if (Serial.available() > 0) {
    // read the incoming byte:
    Serial.readBytes(inBytes, 3);
    
    if(inBytes[0]=='S'){
      if(inBytes[1] == 1){
        if((inBytes[2] >= 0)&&(inBytes[2] <= 180)){
          servo1.write(inBytes[2]);
        }
      }
    }

    if(inBytes[0] == 'D'){
      if(inBytes[1] == 2){
          digitalWrite(9, inBytes[2]);
      }
    }

    if(inBytes[0] == 'E'){
      if(inBytes[1] == 3){
        digitalWrite(10, inBytes[2]);
        delay(1000);
      }
    }

  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('C');
    delay(300);
  }
}

