function main()

    while(1)

%       url = 'http://192.168.1.13/cgi-bin/gettemp.cgi';
        url = 'http://raspberrypi/cgi-bin/gettemp.cgi';
        html = urlread(url);

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
        
        pause(5);
    end;
    
    
end