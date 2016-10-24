% Eugene Park
% Real-Time Temperature sensor with Arduino
% 2016
% Thesis


function Arduino_PID()

%     % THINGSPEAK INFORMATION
%     writeChannelID = 113134;
%     fieldID1 = 2;
%     writeAPIKey = 'RM2WN27AAKC7D99C';
    
    % ARDUINO UNO initialize
    a = arduino('COM4','uno');
    url = 'https://raspberrypi/cgi-bin/gettemp.cgi';
    motorPin = 'D9';

    if (a.Port <1), return; end;
    
    figure(1); clf();
    set(gca,'Color',[0.8 0.8 0.8]);
    zoom on;
    grid on;
    hold on;
    %MyGUIHandles.handle2 = string('');
    
    MyGUIHandles.handle1 = plot(0,0,'--b');
    MyGUIHandles.handle3 = plot(0,0,'-r');
    MyGUIHandles.handle4 = plot(0,0,'-.g');
    
    MyGUIHandles.handle10 = title('');
    %axis([0,100,0,50]);
    legend('Noisy Temperature','Kalman Filter Temperature','Kalman Filter Voltage','Location','southeast');
    xlabel('Time in Seconds');
    ylabel('Temperature in °C');
    
    figure(2);clf(); hold on; grid on; zoom on;
    set(gca,'Color',[0.8 0.8 0.8]);
    MyGUIHandles.handle5 = plot(0,0,'-r');
    MyGUIHandles.handle6 = plot(0,0,'--y');
    MyGUIHandles.handle11 = title('');
    legend('Noisy Voltage','Kalman Filter Voltage','Location','southeast');
    xlabel('Time in Seconds');
    ylabel('Voltage in Volts');
    
    figure(3);clf(); hold on; grid on; zoom on;
    set(gca,'Color',[0.8 0.8 0.8]);
    MyGUIHandles.handle7 = plot(0,0,'-k');
    MyGUIHandles.handle12 = title('');
    legend('Fan Efficiency','Location','southeast');
    limits = [0,100];
    ylim(limits);
    xlabel('Time in Seconds');
    ylabel('Efficiency %');
    
    % initalize some important variables
    i = 1;
    time = 0;
    timets = 0;
    dt = 0.3;
    
    fprintf('Program for arduino uno device is now running\n');
    
    % Kalman Variables
    
    varVolt = 1.12184e-05;
    varTemp = 0.102386;
    varProcess_v = 1e-8;
    varProcess_t = 0.001;
    Pc = 0.0;
    G = 0.0;
    P = 1.0;
    Xp = 0.0;
    Zp = 0.0;
    Xe = 0.0;
    
    Pc_v = 0.0;
    G_v = 0.0;
    P_v = 1.0;
    Xp_v = 0.0;
    Zp_v = 0.0;
    Xe_v = 0.0;
    
    previousVoltage = 0;
    timerValintial = cputime;
    
    fspeed = 0;
    accumError = 0;
    
    pause(5);
    
    while 1,
        tic();
    %if exist(a.Port)
    %hello =1
        
    if a.Port>0
        %if round(time) > 100
            %break;
        %end;
        %time = cputime - timerValintial;
        
        [PI_temperature,PI_voltage] = readHTTP(url);
        
        voltage = PI_voltage;
    
        %voltageArduino     = readVoltage(a,'A0'); % arduino only model
        %voltageArduino;
        %TempArduino = (voltageArduino*100) - 50;
        
        tempinCel    = PI_temperature;
        
        buffer(1,i) = tempinCel;
        buffer(2,i) = time;
     
        buffer(2,:);

        % Kalman Filter Process for temp
        
        Pc = P + varProcess_t;
        G = Pc/(Pc + varTemp); %Kalman Gain
        P = (1-G)*Pc;
        Xp = Xe;
        Zp = Xp;

        Xe = G*(tempinCel-Zp)+Xp;

        %Xetemp  = voltToCe(Xe);
        Xetemp = Xe;
        
        XeBuffer(1,i) = Xetemp;
        
        % Kalman Filter Process for volt
        
        Pc_v = P_v + varProcess_v;
        G_v = Pc_v/(Pc_v + varVolt); %Kalman Gain
        P_v = (1-G_v)*Pc_v;
        Xp_v = Xe_v;
        Zp_v = Xp_v;
        Xe_v = G_v*(voltage-Zp_v)+Xp_v;


        Xetemp_volt  = voltToCe(Xe_v);
           
        XeBuffer_volt(1,i) = Xetemp_volt;
        VeBuffer(1,i) = Xe_v;
        voltBuffer(1,i) = voltage;
        %{
        if i == 500
            filename = 'tempdata.mat';
            save(filename);
        end;
        %}
        
        tempVsTimePlot(tempinCel,MyGUIHandles,buffer,XeBuffer,XeBuffer_volt);
        s= sprintf('Noisy Temp = [%.2f]°C, KALMAN Temp = [%.2f]°C, Voltage Kalman Temp = [%.2f]°C at time [%.3f] secs',tempinCel,Xetemp,Xetemp_volt,time);
        set(MyGUIHandles.handle10,'string',s);
        
        voltageVsTimePlot(MyGUIHandles,buffer,voltBuffer,VeBuffer) 
        s= sprintf('Noisy Voltage = [%.2f]V, Kalman Filtered Voltage = [%.2f]V at time [%.3f] secs',voltage,Xe_v,time);
        set(MyGUIHandles.handle11,'string',s);
        
        %fprintf('Temperature in this room is %.2f°C\n',tempinCel);
        
        previousVoltage = voltage;
    else
        fprintf('Lost connection... waiting for reconnection...');
        a = arduino('COM4','uno');
        voltage = previousVoltage;
        
    end;
        
        avgtemp = mean(XeBuffer);
        if i >1
            prevTemp = XeBuffer(1,i-1);
            [EffMotor,error] = runMotor(a,Xetemp,motorPin,fspeed,accumError,avgtemp,prevTemp);
            fspeed = EffMotor;
            MotorBuffer(1,i) = EffMotor;

            if 0 < fspeed && fspeed < 100
                accumError = accumError + error;
            end;

            motorEfficiencyVsTimePlot(MyGUIHandles,buffer,MotorBuffer) 
            s= sprintf('Motor Running at = [%.2f%%] at time [%.3f] secs',EffMotor,time);
            set(MyGUIHandles.handle12,'string',s);


            %fprintf('Efficiency of motor at [%.2f%%]\n',EffMotor);

            t = datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss');

            timeStamps = t;
            allow = mod(round(time),15); %<--- may f up the thingspeak due to no representation of time
            if allow == 0
                %thingSpeakWrite(writeChannelID, 'Fields',[1,2],'Values',[Xetemp_volt, tempinCel], 'TimeStamps', timeStamps, 'Writekey', writeAPIKey);

            end;
            %{
            wait = 0.2;
            elapsed_t = toc();
            i = i+1;
            time = time + dt + elapsed_t+wait;
            %time = cputime - timerValintial;
            pause(dt);
            %}

        end;
        elapsed_t = toc();
        i = i+1;
        time = time + dt + elapsed_t;
        pause(dt);
        
        
        
        %its not a true real time system because time will still have
        %passed when i press pause in this matlab.
 
    end;
    fprintf('Finished Bye!\n');
end

function tempinCel = voltToCe(voltage)

    tempinCel = (voltage*100) - 45;
    return;
end

function tempVsTimePlot(temp,mh,buffer,Xe,Xe_v) 
    
    set(mh.handle1,'xdata',buffer(2,:),'ydata',buffer(1,:));
    set(mh.handle3,'xdata',buffer(2,:),'ydata',Xe(1,:));
    set(mh.handle4,'xdata',buffer(2,:),'ydata',Xe_v(1,:));
    
 
    return;
end

function voltageVsTimePlot(mh,buffer,voltage,Xe_v) 
    
    set(mh.handle5,'xdata',buffer(2,:),'ydata',voltage(1,:));
    set(mh.handle6,'xdata',buffer(2,:),'ydata',Xe_v(1,:));
 
    return;
end

function motorEfficiencyVsTimePlot(mh,buffer,MotorBuffer) 

    set(mh.handle7,'xdata',buffer(2,:),'ydata',MotorBuffer(1,:));

end


function [EffMotor,error] = runMotor(a,temp,pin,fspeed,accumError,avgtemp,prevTemp)
    maxVolt = 5;
    setpoint = 20;
    Kp = 3;
    Ki = 0.8;
    Kd = 0.8;
    
    fanspeed = fspeed;
    
    error = temp - setpoint;
    
    %if 0 < fanspeed && fanspeed < 100
    %    accumError = accumError + error;
    %end;
    accumError;    

    PID = Kp*error + Ki*accumError + Kd *(prevTemp-temp)
    
    %if PID < 0
    %    PID = 0;
    %end;
    
    if temp > setpoint
        %v = min(error*Kp*maxVolt,maxVolt);
        v = min(PID*maxVolt,maxVolt);
        writePWMVoltage(a,pin,v);
        PercentUsage = v/maxVolt *100;
        %writeDigitalPin(a,pin,1);
    else
        writeDigitalPin(a,pin,0);
        PercentUsage = 0;
    end;

    EffMotor = PercentUsage;
    return;
end

function [temperatureC, voltageV] = readHTTP(url)


    %       url = 'http://192.168.1.13/cgi-bin/gettemp.cgi';

    html = webread(url);

    txt = regexprep(html,'<script.*?/script>','');
    txt = regexprep(txt,'<style.*?/style>','');
    txt = regexprep(txt,'<.*?>','');

    %       temperatureC = txt(133:138)
    key = 'temperature is:';
    ind = strfind(txt,key);
    ind = ind(1);

    key2 = 'voltage is:';
    ind2 = strfind(txt,key2);
    ind2 = ind2(1);

    temperatureC = sscanf(txt(ind+length(key):end), '%g',1)
    voltagemV    = sscanf(txt(ind2+length(key2):end), '%g',1);
    voltageV     = voltagemV/1000


    
end
