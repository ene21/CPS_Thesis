

#include <LiquidCrystal.h> // includes the LiquidCrystal Library 
LiquidCrystal lcd(7, 8, 9, 10, 11, 12); // Creates an LC object. Parameters: (rs, enable, d4, d5, d6, d7) 

const int temperaturePin = 1;

void setup() { 

  Serial.begin(9600);
  lcd.begin(16,2); // Initializes the interface to the LCD screen, and specifies the dimensions (width and height) of the display }
 
}

void loop() { 

  float voltage, degreesC, degreesF;
  voltage = getVoltage(temperaturePin);
  degreesC = (voltage - 0.5) * 100.0;
  degreesF = degreesC * (9.0/5.0) + 32.0;

  Serial.print("voltage: ");
  Serial.print(voltage);
  Serial.print("  deg C: ");
  Serial.print(degreesC);
  Serial.print("  deg F: ");
  Serial.println(degreesF);

  lcd.setCursor(0,0);
  lcd.print("TEMPERATURE: ");
  lcd.setCursor(8,1);
  lcd.print(degreesC);
  lcd.print((char)223);
  lcd.print("C");

  delay(4000);
  
}

float getVoltage(int pin)
{

  
  return (analogRead(pin) * 0.0048876);
  
  // This equation converts the 0 to 1023 value that analogRead()
  // returns, into a 0.0 to 5.0 value that is the true voltage
  // being read at that pin.
}

