% testing the raspberry pi 3 with matlab

function main()

    ipaddress = '192.168.1.16';
    username  = 'pi';
    password  = 'Surfdude1!';

    rpi = raspi(ipaddress,username,password);

    rpi
    %showPins(rpi) % shows the pins available on the pi
    %openShell(rpi) % opens putty sSH 
    %rpi.AvailableSPIChannels
    %enableSPI(rpi)
    %rpi.AvailableSPIChannels
    
    clear mcp3008;
    mcp3008  = spidev(rpi,'CE0');
    data     = uint16(writeRead(mcp3008,[1,bin2dec('10000000'), 0]));
    highbits = bitand(data(2), bin2dec('11'));
    voltage  = double(bitor(bitshift(highbits, 8), data(3)))
    volts  = voltage * 3.3 / 1023
    %voltage  = voltage/1023;
    
    %Xetemp_volt  = voltToCe(voltage)
    tempC = ((voltage*340)/1023)-50
    
    
    pause(10);
    
    data     = uint16(writeRead(mcp3008,[1,bin2dec('10000000'), 0]));
    highbits = bitand(data(2), bin2dec('11'));
    voltage  = double(bitor(bitshift(highbits, 8), data(3)))
    volts  = voltage * 3.3 / 1023
    %voltage  = voltage/1023;
    
    %Xetemp_volt  = voltToCe(voltage)
    tempC = ((voltage*340)/1023)-50
    
    
    
    
    %{
    for i = 1:10

        writeDigitalPin(rpi,18,1);
        pause(0.5);
        writeDigitalPin(rpi,18,0);
        pause(0.5);
    end;
    
    %}
    
    %for i = 1:10
        
        %readDigital
        
    %end;



end


function tempinCel = voltToCe(voltage)

    tempinCel = ((voltage)-0.5)*100 ;
    return;
end