void setup() {
  // put your setup code here, to run once:
  pinMode(5,OUTPUT);
  pinMode(6,OUTPUT);
  digitalWrite(5,LOW);
  digitalWrite(6,LOW);
}

void loop() {
  // put your main code here, to run repeatedly:
  analogWrite(5,255);
  delay(100);
//  analogWrite(5,0);
//  delay(500);
//  analogWrite(6,255);
//  delay(1000);
//  analogWrite(6,0);
//  delay(500);
}
