function pintarAnalisisTemporalMediaDiaCadaMes(nomSerie,dia,ttp24h)
% subplot de 12 plots, cada plot correspondiente a un mes del año con un nº de perfiles 
% igual al nº de años disponibles en donde en ese año el mes está completo
% para asi tener una buena media.

mp24h = [ttp24h{:,1:end}]; 
meses = {'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'};
dias = {'Domingo','Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'};%domingo =1
indDia = weekday(ttp24h.FECHA) == dia;
primerYear = ttp24h.FECHA(1,:).Year;
rangoYears = (ttp24h.FECHA(end,:).Year - ttp24h.FECHA(1,:).Year)+1;
ultimoMes = ttp24h.FECHA(end,:).Month;

if ttp24h.FECHA(end,:).Day < 28 & ttp24h.FECHA(end,:).Month == 1
    rangoYears = rangoYears - 1;
elseif ttp24h.FECHA(end,:).Day < 28 & ttp24h.FECHA(end,:).Month ~=1
    ultimoMes = ttp24h.FECHA(end,:).Month -1;
end
    
figure;
for j=0:rangoYears
    indYear = ttp24h.FECHA.Year == j + primerYear;
    for i=1:12 
        
        indMonth = ttp24h.FECHA.Month == i;   
        media = mean(mp24h(indDia & indMonth & indYear ,:));
        sgtitle(sprintf('Perfil %s Cada Mes',dias{dia}));
        subplot(4,3,i);
        hold on;
        plot(media); 
        axis tight;
        title(meses{i}); 
        
        if i == ultimoMes & j == rangoYears
            break;
    end
end

end

