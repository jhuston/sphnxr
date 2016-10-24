/*
  ReadAnalogVoltage
  Reads an analog input on pin 0, converts it to voltage, and prints the result to the serial monitor.
  Graphical representation is available using serial plotter (Tools > Serial Plotter menu)
  Attach the center pin of a potentiometer to pin A0, and the outside pins to +5V and ground.

  This example code is in the public domain.
*/

// the setup routine runs once when you press reset:
void setup() {
  // initialize serial communication at 9600 bits per second:
  Serial.begin(115200);
}

// the loop routine runs over and over again forever:
void loop() {
  Serial.write(253); // indx 0
  Serial.write(254); // indx 1
  serialPrint(analogRead(A0)); // indx 2,3
  serialPrint(analogRead(A1)); // indx 4,5
  serialPrint(analogRead(A2)); // indx 6,7
  serialPrint(analogRead(A3)); // indx 8,9
  serialPrint(analogRead(A4)); // indx 10,11
  serialPrint(analogRead(A5)); // indx 12,13
  serialPrint(analogRead(A6)); // indx 14,15
  serialPrint(analogRead(A7)); // indx 15,16
  serialPrint(analogRead(A8)); // indx 17,18
  serialPrint(analogRead(A9)); // indx 19,20
  serialPrint(analogRead(A10)); // indx 21,22
  serialPrint(analogRead(A11)); // indx 23,24
  Serial.write(255);  // indx 25
  delay(50); 
}

void serialPrint(int val) { 
  Serial.write(val>>2);  //bits 2-9 
  Serial.write(val&3);   //bits 0-1 
} 
