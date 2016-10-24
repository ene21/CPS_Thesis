readChannelID = 113134;
fieldID1 = 2;
readAPIKey = '5XLG5ZMNUJDTRF3E';

figure(5);
MyGUIHandles.handle1 = plot(0,0,'.b');

while 1,
% READ DATA
[data,time] = thingSpeakRead(readChannelID,'Field',fieldID1,'NumPoints',10,'ReadKey',readAPIKey);


data
time
numel(data)






pause(2);

end;