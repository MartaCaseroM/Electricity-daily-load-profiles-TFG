function ttp24h = creaPerfilRepartoUnaSerie(nomSerie, th)

% a partir de los datos horarios normalizados en th crea una nueva tabla
% con los perfiles correspondientes

PINTAR = false;

tth = table2timetable(th,'RowTimes','FECHAHORA');

% serie diaria
ttd = retime(tth,'daily','sum'); %suma todas las horas de ese día



% generamos perfil horario normalizado de demanda p= h/d
ttph = synchronize(tth,ttd,'hourly','previous');
ttph.PERFILH = ttph.DEM_tth ./ ttph.DEM_ttd;
%ttaux(1:50,:)


%% preparamos tabla con las 24h en columnas
ttp24h = ttph;
ttp24h(:,1:2)=[];%elimino columnas de demanda

%crear columna de hora y columna con solo la fecha sin hora
ttp24h.HORA = ttp24h.FECHAHORA.Hour;
ttp24h.FECHA = datetime(ttp24h.FECHAHORA.Year,ttp24h.FECHAHORA.Month, ttp24h.FECHAHORA.Day);%conseguir columna de solo dia

% pasamos a tabla para hacer el unstack, eliminando la columna de fechahora
tp24h = timetable2table(ttp24h);
tp24h(:,'FECHAHORA')=[];
tp24h = unstack(tp24h,'PERFILH','HORA');

%cambiamos nombres de las columnas y convertimos en timetable nuevamente
tp24h.Properties.VariableNames = regexprep(tp24h.Properties.VariableNames, 'x','PERFILH');
ttp24h = table2timetable(tp24h,'RowTimes','FECHA');

%muestra
if PINTAR
    figure;
    plot(tth.FECHAHORA, tth.DEM, '.-');
    
    figure;
    ax(1)= subplot(2,1,1); hold on;
    plot(ttd.FECHAHORA, ttd.DEM, '.-');
    title ('diaria');
    ax(2)= subplot(2,1,2); hold on;
    plot(tth.FECHAHORA, tth.DEM, '.-');
    linkaxes(ax,'x');
    
    figure;
    ax1(1)= subplot(3,1,1); hold on;
    plot(ttph.FECHAHORA, ttph.DEM_ttd, '.-');
    title ('diaria');
    ax1(2)= subplot(3,1,2); hold on;
    plot(ttph.FECHAHORA, ttph.DEM_tth, '.-');
    linkaxes(ax,'x');
    ax1(3)= subplot(3,1,3); hold on;
    plot(ttph.FECHAHORA, ttph.PERFILH, '.-');
    linkaxes(ax,'x');
    
    %mostramos los coefs de cada hora por separado
    figure;
    stackedplot(ttp24h);
    figure;
    plot(ttp24h.FECHA, [ttp24h.Variables]);
end

end






