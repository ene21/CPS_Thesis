function main()

clc;
clf();

a = arduino('COM4','uno');

motorPin = 'D9';

writeDigitalPin(a,motorPin,1);

pause(5);

writeDigitalPin(a,motorPin,0);

pause(5);

writePWMVoltage(a,motorPin,1);

pause(2);

writePWMVoltage(a,motorPin,2);

pause(2);

writePWMVoltage(a,motorPin,3);

pause(2);

writePWMVoltage(a,motorPin,4);

pause(5);

writePWMVoltage(a,motorPin,5);

pause(2);

writeDigitalPin(a,motorPin,1);

pause(5);

writeDigitalPin(a,motorPin,0);


end