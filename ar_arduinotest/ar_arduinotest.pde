import processing.serial.*;
import processing.net.*;

Server server;
Serial serialPort; 

boolean firstContact = false;  

byte[] inByte = new byte[3]; 

int oval1;
int oval2;
int oval3;

String serverAddress = "localhost";
Client client;

void setup() {
  size(200, 200);
  
  client = new Client(this, serverAddress, 5555);
  
  println(Serial.list()); 
  String portName = Serial.list()[0]; 
  serialPort = new Serial(this, portName, 9600);
  serialPort.buffer(inByte.length);

  oval1 = 90;
  oval2 = 0;
  oval3 = 0;
}

void draw() {
  background(0);

  text("Output port 1: " + oval1, 10, 100);
  text("Output port 2: " + oval2, 10, 130);
  text("Output port 3: " + oval3, 10, 160);
}

void serialEvent(Serial port) {
  inByte = port.readBytes();

  if(firstContact == false) {
    if(inByte[0] == 'C') { 
      port.clear();
      firstContact = true;
      sendServo(1, 0);
      sendServo2(2, 0);
      sendServo3(3, 0);
    } 
  }
}


void sendServo(int id, int value)
{
  if(!firstContact) return;
  int v = value;
  if(v < 0) v = 0; 
  if(v > 90) v = 90; 
  serialPort.write((byte)'S');
  serialPort.write((byte)id);
  serialPort.write((byte)v);
}

void sendServo2(int id, int value)
{
  if(!firstContact) return;
  int v = value;
  if(v < 0) v = 0; 
  if(v > 255) v = 255; 
  serialPort.write((byte)'D');
  serialPort.write((byte)id);
  serialPort.write((byte)v);
}

void sendServo3(int id, int value)
{
  if(!firstContact) return;
  int v = value;
  if(v < 0) v = 0; 
  if(v > 255) v = 255; 
  serialPort.write((byte)'E');
  serialPort.write((byte)id);
  serialPort.write((byte)v);
}

void clientEvent(Client c) {
  String s = c.readStringUntil('\n');
  if (s != null) {
    print("received from server: " + s);
    String[] data = s.trim().split(",");
    for(int i = 0; i < data.length; i++){
      if(data[i] == "1");
      int x = parseInt(data[0]);
      int y = parseInt(data[1]);
    }
  }
}

void keyPressed() {
  switch(key){
    case 'z':
    if(oval1 < 90){
      oval1 += 1; 
      sendServo(1, oval1);
    }
    break;
    
  case 'x':
    if(oval1 > 0){
      oval1 -= 1; 
      sendServo(1, oval1);
    }
    break;
 
  case 'c':
    oval1 = 0;
    sendServo(1, oval1);
    break;
  
  case 'v':
    oval1 = 90;
    sendServo(1, oval1);
    break;
    
  case 'f':
    oval2 = 255;
    sendServo2(2, oval2);
    break;
  
  case 'd':
    oval2 = 0;
    sendServo2(2, oval2);
    break;
    
  case 'r':
    oval3 = 255;
    sendServo3(3, oval3);
    break;
   
  case 'e':
    oval3 = 0;
    sendServo3(3, oval3);
    break;
    
  default:
    break;
  }
}