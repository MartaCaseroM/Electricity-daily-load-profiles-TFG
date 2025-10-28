function analisisTemporalDiaEspecifico(nomSerie,dia,ttp24h)
% plot con 12 perfiles medios para cada mes del año correspondientes a un 
% día de la semana determinado
% dia = 1;
%nomSerie = 'DEMELEH#P48';

mp24h = [ttp24h{:,1:end}]; 
indDia = weekday(ttp24h.FECHA) == dia;
meses = {'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'};
dias = {'Domingo','Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'};
%figure;
for i=1:12
    indMonth = ttp24h.FECHA.Month == i;
    media = mean(mp24h(indDia & indMonth,:));
    hold on;
    plot(media,'Linewidth',2.0);
    title(sprintf('Perfil mensual del %s - Tarifa %s',dias{dia}, nomSerie));
    axis tight;
end
xlabel('Hora');
xticks(1:24);
xticklabels(0:23);
ylabel('Demanda eléctrica normalizada');
end