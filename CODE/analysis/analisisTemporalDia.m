function analisisTemporalDia(nomSerie,dia,ttp24h)
% plot con 12 perfiles medios para cada mes del año correspondientes a un 
% día de la semana determinado
% dia = 1;
%nomSerie = 'DEMELEH#P48';

mp24h = [ttp24h{:,1:end}]; 
indDia = weekday(ttp24h.FECHA) == dia;
meses = {'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'};
dias = {'Domingo','Lunes','Martes','Miércoles','Jueves','Viernes','Sábado'};
%figure;
for i=1:12
    indMonth = ttp24h.FECHA.Month == i;
    media = mean(mp24h(indDia & indMonth,:));
    hold on;
    plot(media);
    title(sprintf('%s'),dias{dia});
    axis tight;
end
end