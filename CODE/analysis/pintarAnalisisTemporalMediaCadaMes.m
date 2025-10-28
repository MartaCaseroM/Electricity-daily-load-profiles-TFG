function pintarAnalisisTemporalMediaCadaMes(nomSerie,year,ttp24h)
% subplot de 12 plots, cada plot correspondiente a un mes del año con un nº de perfiles 
% igual al nº de años disponibles en donde en ese año el mes está completo
% para asi tener una buena media.

mp24h = [ttp24h{:,1:end}]; 
meses = {'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'};
dias = {'Domingo','Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'};%domingo =1


indYear = ttp24h.FECHA.Year == year;    
figure;

for i=1:12 

    indMonth = ttp24h.FECHA.Month == i;   
    media = mean(mp24h(indMonth & indYear ,:));
    
    subplot(4,3,i);
    hold on;
    plot(media); 
    axis tight;
    title(meses{i}); 

    
end
sgtitle(sprintf('Perfil de cada Mes año %d %s',year,nomSerie));
linkaxes;
end

