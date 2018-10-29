import processing.serial.*;
import processing.net.*;


Server server;
Serial serialPort; 
boolean firstContact = false;  

byte[] inByte = new byte[3]; 
String[] xp;

int x;
int oval1;
int oval2;
int oval3;

void setup() {
  size(200, 200);
  
  server = new Server(this, 12345);
  
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
  
  Client client = server.available();

  if (client!=null) {
    // println("Client IP Address : " + client.ip());
    if(client.available() > 0){
      String clientData = client.readString();
      
      // println(clientData + "\n");

      String[] httpRequest=trim(split(clientData,'\n'));
      String http[];
      // GET /3 HTTP/1.1
      
      for(int i = 0; i < httpRequest.length; i++){
        if(httpRequest[i].contains("GET")){
         
          http = trim(split(httpRequest[i], " HTTP/1.1"));
          println(httpRequest[i]);
          String[] list = split(httpRequest[i], " HTTP/1.1");
          //println(list[0]);
          String[] list2 = split(list[0], " /?");
          
          println(int(list2[1]));
          x = int(list2[1]) - 600;
          
        }
      }
      int xoff = abs(x - 600);
      
      if(xoff <= 200){
        
        sendServo(1, 0);
        delay(2000);
        sendServo(1, 90);
      } else if(x > 200){
        println("left");
        
        sendServo2(2, x / 10);
        delay(500);
        sendServo2(2, 0);
      } else if(x < -200){   
        println("right");
        sendServo3(3, x / 10);
        delay(500);
        sendServo3(3, 0);
      }
      
      client.stop();
    } 
  }
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
    oval2 = 200;
    sendServo2(2, oval2);
    break;
  
  case 'd':
    oval2 = 0;
    sendServo2(2, oval2);
    break;
    
  case 'r':
    oval3 = 200;
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