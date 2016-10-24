x = [1 2 3 4 5 6];
y = [10 10 10 20 20 20];



i = 1;

while i<= numel(x)
    
    figure(1);clf(); hold all; zoom on; grid on;
    
    hold on;
    axis([0,10,0,40]);
    if y(i) < 15
        plot(x,y);
        
    else
        if y(i) > 15
            set(MyGUIHandles.handle1,'xdata',x(i),'ydata',y(i),'color','r');
        end;
    end;
    
    
    i = i+1;
    pause(0.5);
end;

