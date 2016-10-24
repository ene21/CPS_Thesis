function main()

    x = 2;
    y = 3;
    
    [something,and] = doit(x,y);
    
    something 
    and
end


function [something,and] = doit(x,y);

    something = x*y;
    and = x+y;

    return;
end