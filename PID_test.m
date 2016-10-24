% PID practice
clear all;
temp = [20 20 20 20 23 23 23 23 23 23 23 23 22 22 22 22 22 22 21 21 21 21 21 20 20 20 20 19 19 19 ];

num = numel(temp);

fanspeed = 0;
setpoint = 23;
error = 0;
averageTemp = 0;
accumulatedEr = 0;
error;

for i=1:num
    
    error = setpoint - temp(i);
    PidP = 0.05;
    PidI = 0.001;
    PidD = 0.1;
    
    if 0< fanspeed<100 
        accumulatedEr = accumulatedEr + error;
        
    end;
    storage(i) = temp(i);
    
    averageTemp = mean(storage)
    
    
    fanspeed = PidP*error+PidI* accumulatedEr+PidD*(averageTemp-temp(i))
    
    
    pause(0.1);
    
    fanspeedstor(i) = fanspeed;
    istor(i) = i;
    
    
end;

plot(istor,fanspeedstor,'.b');