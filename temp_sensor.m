
function main()
clear all;
clc;
a = arduino('COM4','uno')
interv = 1000;
passo  = 1;

t = 1;
while (t<interv)
    voltage     = readVoltage(a,'A5');
    b    = (voltage*100) - 50;
    plot(t,b);
    axis([0,interv,0,50]);
    t = t+passo;
    hold on;
    grid on;
    drawnow;
    pause(0.1);
end;
    return;
end