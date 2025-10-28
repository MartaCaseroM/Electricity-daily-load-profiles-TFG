function boxplotPorMesesDiaEspecifico(nomSerie,dia,ttp24h)
%subplot de 12 figures de boxplots correspondientes a perfil de un día de
%la semana determinado para cada mes.

% media de los lunes de cada mes y hacer 12 perfiles
mp24h = [ttp24h{:,1:end}]; 
meses = {'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'};
dias = {'Domingo','Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'};%domingo =1
indDia = weekday(ttp24h.FECHA) == dia;
figure;
for i=1:12    
    indMonth = ttp24h.FECHA.Month == i;   
    sgtitle(sprintf('Perfil %s Cada Mes',dias{dia}));
    subplot(4,3,i);
    boxplot(mp24h(indDia & indMonth,:));
    title(meses{i});
end
end
