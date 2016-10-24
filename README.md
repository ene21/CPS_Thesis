# Designing a Testbed to Assess Secure Control of Cyber Physical Systems
This repository stores all the codes and informations to the UNSW Thesis B Research on Cyber Physical Systems

Within the folder of MATLAB, there will be numerous files and folders. 
Here are some details starting with the most important:

- The directory of the RPIserver holds the final code used for the thesis testbed.
  - Arduino_PID_https.m     code used for the entire testbed when reading from a secured server
  - Arduino_PID_http.m      code used for the entire testbde when reading from an unsecure server
  - readingHTTPS.m          code used for testing of secure communication from Server to MATLAB
  - readingHTTP.m           code used for testing of unsecure communication from Server to MATLAB
  - raspberrypi.crt         the certificate used to allow MATLAB to access the secure server.
  
-  The directory of initialTestbed holds the first fully function code of the system. This however implemented a different communication protocol
  - DEVICE_PI_ARDUINO.m     code that was initially used, in which MATLAB was communicating to the Pi via a Secure Shell.
  
- The tmpLCD directory holds the code for the Arduino MEGA 2560 that was implemented at a later date
  - tmpLCD.ino              code that was used on the MEGA to display the experiments control temperature sensor on an LCD.
  
  
  


