ruta = '..\DATA';


nomSerie = 'DEMELEH#P48';
tarifa20 = 'SEGELEH#TA20';
tarifa21 = 'SEGELEH#TA21';
tarifa30A = 'SEGELEH#TA30A';
tarifa31A = 'SEGELEH#TA31A';
tarifa61A = 'SEGELEH#TA61A';


nomFi = sprintf('%s.txt',nomSerie);
fullFi = fullfile(ruta,nomFi);
%th = normalizaDatosHorarios(fullFi);
nomFiTarifa20 = sprintf('%s.txt',tarifa20);
fullFiTarifa20 = fullfile(ruta,nomFiTarifa20);
nomFiTarifa21 = sprintf('%s.txt',tarifa21);
fullFiTarifa21 = fullfile(ruta,nomFiTarifa21);
nomFiTarifa30A = sprintf('%s.txt',tarifa30A);
fullFiTarifa30A = fullfile(ruta,nomFiTarifa30A);
nomFiTarifa31A = sprintf('%s.txt',tarifa31A);
fullFiTarifa31A = fullfile(ruta,nomFiTarifa31A);
nomFiTarifa61A = sprintf('%s.txt',tarifa61A);
fullFiTarifa61A = fullfile(ruta,nomFiTarifa61A);

% opts = detectImportOptions(fullFi);
% opts = setvartype(opts,'FECHAHORA',{'datetime'})

th = readtable(fullFi);
th.FECHAHORA = datetime(th{:,1},'inputformat','uuuu-MM-dd''T''HHZZZZ','Timezone','Europe/Zurich','locale','es_ES', 'Format', 'dd/MM/yyyy HH');
th = normalizaDatosHorarios(th);
th20 = readtable(fullFiTarifa20);
th20.FECHAHORA = datetime(th20{:,1},'inputformat','uuuu-MM-dd''T''HHZZZZ','Timezone','Europe/Zurich','locale','es_ES', 'Format', 'dd/MM/yyyy HH');
th21 = readtable(fullFiTarifa21);
th21.FECHAHORA = datetime(th21{:,1},'inputformat','uuuu-MM-dd''T''HHZZZZ','Timezone','Europe/Zurich','locale','es_ES', 'Format', 'dd/MM/yyyy HH');
th30A = readtable(fullFiTarifa30A);
th30A.FECHAHORA = datetime(th30A{:,1},'inputformat','uuuu-MM-dd''T''HHZZZZ','Timezone','Europe/Zurich','locale','es_ES', 'Format', 'dd/MM/yyyy HH');
th31A = readtable(fullFiTarifa31A);
th31A.FECHAHORA = datetime(th31A{:,1},'inputformat','uuuu-MM-dd''T''HHZZZZ','Timezone','Europe/Zurich','locale','es_ES', 'Format', 'dd/MM/yyyy HH');
th61A = readtable(fullFiTarifa61A);
th61A.FECHAHORA = datetime(th61A{:,1},'inputformat','uuuu-MM-dd''T''HHZZZZ','Timezone','Europe/Zurich','locale','es_ES', 'Format', 'dd/MM/yyyy HH');

% ya en th en el cambio de hora de verano se salt la hora 2
% y para el cambio en invierno se tiene dos veces la hora 2 y no es con el
% mismo valor
% pasamos a timetable
tth = table2timetable(th,'RowTimes','FECHAHORA');
tth20 = table2timetable(th20,'RowTimes','FECHAHORA');
tth21 = table2timetable(th21,'RowTimes','FECHAHORA');
tth30A = table2timetable(th30A,'RowTimes','FECHAHORA');
tth31A = table2timetable(th31A,'RowTimes','FECHAHORA');
tth61A = table2timetable(th61A,'RowTimes','FECHAHORA');


figure;
plot(tth.FECHAHORA, tth.DEM, '.-');


% serie diaria
ttd = retime(tth,'daily','sum'); %suma todas las horas de ese día
ttd20 = retime(tth20,'daily','sum');
ttd21 = retime(tth21,'daily','sum');
ttd30A = retime(tth30A,'daily','sum');
ttd31A = retime(tth31A,'daily','sum');
ttd61A = retime(tth61A,'daily','sum');

figure;
ax(1)= subplot(2,1,1); hold on;
plot(ttd.FECHAHORA, ttd.DEM, '.-');
title ('diaria');
ax(2)= subplot(2,1,2); hold on;
plot(tth.FECHAHORA, tth.DEM, '.-');
linkaxes(ax,'x');



% generamos perfil horario normalizado de demanda p= h/d

ttph = synchronize(tth,ttd,'hourly','previous');
ttph.PERFILH = ttph.DEM_tth ./ ttph.DEM_ttd;
%ttaux(1:50,:)
ttph20 = synchronize(tth20,ttd20,'hourly','previous');
ttph20.PERFILH = ttph20.DEM_tth20 ./ ttph20.DEM_ttd20;
ttph21 = synchronize(tth21,ttd21,'hourly','previous');
ttph21.PERFILH = ttph21.DEM_tth21 ./ ttph21.DEM_ttd21;
ttph30A = synchronize(tth30A,ttd30A,'hourly','previous');
ttph30A.PERFILH = ttph30A.DEM_tth30A ./ ttph30A.DEM_ttd30A;
ttph31A = synchronize(tth31A,ttd31A,'hourly','previous');
ttph31A.PERFILH = ttph31A.DEM_tth31A ./ ttph31A.DEM_ttd31A;
ttph61A = synchronize(tth61A,ttd61A,'hourly','previous');
ttph61A.PERFILH = ttph61A.DEM_tth61A ./ ttph61A.DEM_ttd61A;


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

timerangeGenerica = timerange("1/1/2015","11/1/2020");%formato mm-dd-aaaa
ttphGen = ttph(timerangeGenerica,:);
%comparacion de perfiles tarifa 2.0 y 3.0A
figure;
ax2(1)= subplot(3,1,1); hold on;
plot(ttph20.FECHAHORA, ttph20.DEM_ttd20, '.-');
plot(ttph30A.FECHAHORA, ttph30A.DEM_ttd30A, '.-');
%plot(ttphGen.FECHAHORA, ttphGen.DEM_ttd, '.-'); % error, porque ttphGen no
%tiene Timezone y con las que se está comparando si.
title('Tarifa2.0 vs. Tarifa3.0A - Diaria');
legend('2.0','3.0A','P48');
ax2(2)= subplot(3,1,2); hold on;
plot(ttph20.FECHAHORA, ttph20.DEM_tth20, '.-');
plot(ttph30A.FECHAHORA, ttph30A.DEM_tth30A, '.-');
title('Tarifa2.0 vs. Tarifa3.0A - Horaria');
linkaxes(ax2,'x');
ax2(3)= subplot(3,1,3); hold on;
plot(ttph20.FECHAHORA, ttph20.PERFILH, '.-');
plot(ttph30A.FECHAHORA, ttph30A.PERFILH, '.-');
linkaxes(ax2,'x');
title('Tarifa2.0 vs. Tarifa3.0A - Perfiles');



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

 

%mostramos los coefs de cada hora por separado
figure;
stackedplot(ttp24h);
figure;
plot(ttp24h.FECHA, [ttp24h.Variables]);
mp24h = [ttp24h{:,1:end}];
figure;
plot(mp24h');
figure;
boxplot(mp24h);

ind = ttp24h.FECHA.Month == 8;
ind1 = ttp24h.FECHA.Month == 1;
figure;
boxplot(mp24h(ind,:));
figure;
boxplot(mp24h(ind1,:));

ind7 = weekday(ttp24h.FECHA) == 7;
ind5 = weekday(ttp24h.FECHA) == 5;
figure;
boxplot(mp24h(ind7 & ind1 ,:));
figure;
boxplot(mp24h(ind5 & ind1 ,:));

media = mean(mp24h(ind5 & ind1 ,:));
media7 = mean(mp24h(ind7 & ind1 ,:));
figure;
hold on;
plot(media);
plot(media7);

figure;
hold on;
plot([mp24h(ind5 & ind1 ,:)]','r');
plot(media,'k');

%en la demanda global conjunta de todas las tarifas tenemos picos en los
%perfiles los días de cambio de hora en invierno ya que se tiene una hora
%mas de consumo en dicho día.
%justo la hora pico del cambio en invierno equivale al Perfil en la Hora 2
%(el doble que el de otro día cualquiera a la misma hora)

% la forma de embudo se podría dar a que después del cambio de hora en
% marzo, se nota mas el ahorro enérgetico debido al cambio de hora pero
% llegado los meses de verano va aumentando debido al mayor uso del aire
% acondicionado. Después, en el cambio de hora en octubre, se intenta
% conseguir un ahorro pero debido a la calefacción y que las personas
% suelen estar mas en casa, se sigue consumiendon bastante.
 
ttp24h20 = ttph20;
ttp24h20(:,1:2)=[];%elimino columnas de demanda

 

%crear columna de hora y columna con solo la fecha sin hora
ttp24h20.HORA = ttp24h20.FECHAHORA.Hour;
ttp24h20.FECHA = datetime(ttp24h20.FECHAHORA.Year,ttp24h20.FECHAHORA.Month, ttp24h20.FECHAHORA.Day);%conseguir columna de solo dia

 

% pasamos a tabla para hacer el unstack, eliminando la columna de fechahora
tp24h20 = timetable2table(ttp24h20);
tp24h20(:,'FECHAHORA')=[];
tp24h20 = unstack(tp24h20,'PERFILH','HORA');

 

%cambiamos nombres de las columnas y convertimos en timetable nuevamente
tp24h20.Properties.VariableNames = regexprep(tp24h20.Properties.VariableNames, 'x','PERFILH');
ttp24h20 = table2timetable(tp24h20,'RowTimes','FECHA');

 

%mostramos los coefs de cada hora por separado
figure;
stackedplot(ttp24h20);
figure;
plot(ttp24h20.FECHA, [ttp24h20.Variables]);

ttp24h61A = ttph61A;
ttp24h61A(:,1:2)=[];%elimino columnas de demanda

 

%crear columna de hora y columna con solo la fecha sin hora
ttp24h61A.HORA = ttp24h61A.FECHAHORA.Hour;
ttp24h61A.FECHA = datetime(ttp24h61A.FECHAHORA.Year,ttp24h61A.FECHAHORA.Month, ttp24h61A.FECHAHORA.Day);%conseguir columna de solo dia

 

% pasamos a tabla para hacer el unstack, eliminando la columna de fechahora
tp24h61A = timetable2table(ttp24h61A);
tp24h61A(:,'FECHAHORA')=[];
tp24h61A = unstack(tp24h61A,'PERFILH','HORA');

 

%cambiamos nombres de las columnas y convertimos en timetable nuevamente
tp24h61A.Properties.VariableNames = regexprep(tp24h61A.Properties.VariableNames, 'x','PERFILH');
ttp24h61A = table2timetable(tp24h61A,'RowTimes','FECHA');

 

%mostramos los coefs de cada hora por separado
figure;
stackedplot(ttp24h61A);
figure;
plot(ttp24h61A.FECHA, [ttp24h61A.Variables]);

mat = [ttp24h.Variables];
figure;
pcolor(mat');
colorbar;
shading flat;

