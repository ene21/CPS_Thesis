function main()

    while(1)

        url = 'https://raspberrypi/cgi-bin/gettemp.cgi';
%         html = ReadUrl(url);
        html = webread(url);
       


        txt = regexprep(html,'<script.*?/script>','');
        txt = regexprep(txt,'<style.*?/style>','');
        txt = regexprep(txt,'<.*?>','')
        
%       temperatureC = txt(133:138)
        key = 'temperature is:';
        ind = strfind(txt,key);
        ind = ind(1);
        temperatureC = sscanf(txt(ind+length(key):end), '%g',1)
        
        
        pause(10);
    end;
    
    
end

function str = ReadUrl(url)
     is = java.net.URL([], url, sun.net.www.protocol.https.Handler).openConnection().getInputStream(); 
     br = java.io.BufferedReader(java.io.InputStreamReader(is));
     str = char(br.readLine());
 end