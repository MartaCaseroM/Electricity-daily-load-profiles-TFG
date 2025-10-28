function analisisTemporalPerfilDiaYMesEspecifico(nomSerie,dia,mes,ttp24h)
% plot de las medias de los perfiles de un dia y mes determinado para los
% distintos años disponibles y en los cuales los meses tienen mas de 27 días (para realizar mejor media 
% y que estén completos los días).


mp24h = [ttp24h{:,1:end}]; 
indDia = weekday(ttp24h.FECHA) == dia;
indMonth = ttp24h.FECHA.Month == mes;
primerYear = ttp24h.FECHA(1,:).Year;
rangoYears = (ttp24h.FECHA(end,:).Year - ttp24h.FECHA(1,:).Year);
meses = {'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'};
dias = {'Domingo','Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'};

mesUltimaFecha = ttp24h.FECHA(end,:).Month;
diaUltimaFecha = weekday(ttp24h.FECHA(end,:));
% mes completo porque sino la fecha no hace una buena media
if mesUltimaFecha < mes | ttp24h.FECHA(end,:).Day < 28
    rangoYears = rangoYears - 1;
end
years = {string(primerYear:primerYear + rangoYears)};
figure;
for i=0:rangoYears
    indYear = ttp24h.FECHA.Year == i + primerYear;
    tam = size(mp24h(indDia & indMonth & indYear ,:));
    if tam(1) == 1
        media = mp24h(indDia & indMonth & indYear ,:);
    else
        media = mean(mp24h(indDia & indMonth & indYear ,:)); 
    end
    title(sprintf('Análisis Temporal Dia %s del Mes %s - Tarifa %s',dias{dia},meses{mes}, nomSerie));
    hold on;
    plot(media);    
end
xlabel('Hora');
xticks(1:24);
xticklabels(0:23);
ylabel('Demanda eléctrica normalizada');
legend(years{:});
l = legend(years{:});
l.ItemHitFcn = @hitcallback_ex1;
axis tight;
end
