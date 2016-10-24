x = [1 2 3 4 5 6];
y = [10 10 10 20 20 20];

figure(1);clf(); hold all; zoom on; grid on;
MyGUIHandles.handle1 = plot(0,0,'.b','MarkerSize',5);
hold on;
axis([0,10,0,40]);

i = 1;

while i<= numel(x)
    
    
    if y(i) < 15
        set(MyGUIHandles.handle1,'xdata',x(i),'ydata',y(i),'color','b');
        hold on;
    else
        if y(i) > 15
            set(MyGUIHandles.handle1,'xdata',x(i),'ydata',y(i),'color','r');
        end;
    end;
    
    
    i = i+1;
    pause(0.5);
end;

