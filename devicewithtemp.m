clc;
clear all;

comport = serial('COM3','BaudRate',9600);
fopen(comport);
x=0;
while x<100
    y1(x)=fscanf(comport,'%d');
    
    drawnow;
    plot(y1,'r--','linewidth',3)
    grid on;
    hold on;
    
    xlabel('Time in seconds');
    ylabel('Temperature');
    pause(0.1);
end;