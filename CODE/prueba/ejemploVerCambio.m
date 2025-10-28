ind1 = th.FECHAHORA.Hour==1;
ind2 = th.FECHAHORA.Hour==2;
ind3 = th.FECHAHORA.Hour==3;
figure;hold on;
plot(th.FECHAHORA(ind1), th.DEM(ind1),'.-');
plot(th.FECHAHORA(ind2), th.DEM(ind2),'k.-');
plot(th.FECHAHORA(ind3), th.DEM(ind3),'.-')


falta = ismissing(th);
%startDate = datetime(tth.FECHAHORA(1),'Format', 'dd/MM/yyyy HH');
%endDate = datetime(tth.FECHAHORA(end),'Format', 'dd/MM/yyyy HH');
%rango = startDate:hours(1):endDate;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% esto resolvería el problema de que falta la hora2 en el cambio de hora de verano
ttp24haux = ttp24h;
ttp24haux.PERFILH2=fillmissing(ttp24haux.PERFILH2,'previous'); %del dia anterior

%% intentar hacerlo mucho antes
%% opción 1: con búcle
VECFECHAS=datevec(th.FECHAHORA); %columna 4 es la de la hora
horas = VECFECHAS(:,4);
falta=[];
i=0;
for j=1:size(horas,1)    
    if i~=horas(j)
        if i==2 %
            falta= [falta j];
        elseif i==3
            i=i+1;  
        end
    end    
    if i==23
        i=0;
    else
        i=i+1;  
    end
end
fechafalta=th.FECHAHORA(falta(1));
fechafalta=fechafalta-hours(1);%nada, me salta a la hora 1, por lo que identifica que no existe la hora 2 en el cambio hora verano

%% opción 2:cambiarlo a datavec
fechafalta=th.FECHAHORA(falta(1));
vecfechafalta=datevec(fechafalta);
vecfechafalta(4)=2;
fechafalta1=datetime(vecfechafalta,'Format','dd/MM/yyyy HH','TimeZone','Europe/Zurich');
demfalta=th.DEM((th.FECHAHORA==fechafalta));
fechafalta1=table(fechafalta1,demfalta,'VariableNames',{'FECHAHORA','DEM'});
fechafalta1=table2timetable(fechafalta1,'RowTimes','FECHAHORA');
tth=[fechafalta1 ;tth];%nada, me cambia la hora a hora 3

%% opción3: usar retime
tth =retime(tth, 'hourly', 'previous'); %% no funciona, no identifica que falte la hora 2, porque claro en verdad esa hora no existe


%%
thAU = retime(tth,'hourly', 'previous');
vecFECHA = datevec(tth.FECHAHORA);
vecFECHA = [vecFECHA tth.DEM];
falta=ismissing(vecFECHA(:,4));
ind4 = thAUX.FECHAHORA =='25/03/2018 02';
dt = minutes(60);
THAUX =datevec(thAUX.FECHAHORA);


taux=tth;
thaux.FECHAHORA = datetime(th.FECHAHORA,'inputformat', 'dd/MM/yyyy HH','Format', 'dd/MM/yyyy HH');


%% cambio fecha invierno
rangoFechas = timerange(ttp24h.FECHA(1,:),ttp24h.FECHA(end,:))
rangoYears = ttp24h.FECHA(end,:).Year - ttp24h.FECHA(1,:).Year;
%%ttp24haux=ttp24h;

%si los datos del último año no contienen datos para octubre.
if ttp24haux.FECHA(end,:).Month < 10 & ttp24haux.FECHA(end,:).Day<=31 
    rangoYears = rangoYears-1;
end
for i=0:rangoYears   
    mesOctubre = ttp24haux.FECHA.Year==(ttp24haux.FECHA.Year(1,:) +i) & ttp24haux.FECHA.Month==10;
    ttp24hOct = ttp24haux(mesOctubre,:)
    [valor,posicion] = max(ttp24hOct.PERFILH2); 
    fechacambio= ttp24hOct.FECHA(posicion);    
    ttp24haux(ttp24haux.FECHA==fechacambio,:).PERFILH2 = valor/2;
end

figure;
plot(ttp24haux.FECHA, [ttp24haux.Variables]);


%%

th = readtable(fullFi);
th.FECHAHORA = datetime(th{:,1},'inputformat','uuuu-MM-dd''T''HHZZZZ','Timezone','Europe/Madrid','locale','es_ES', 'Format', 'dd/MM/yyyy HH');

 

% detectamos cambios de hora
ind23h = find(diff(th.FECHAHORA.Hour)==2); % meter una hora despues de este valor
ind25h = find(diff(th.FECHAHORA.Hour)==0); % Calcular la media de este valor con el siguiente

 

th(ind23h,:)
th(ind25h,:)

 

figure;
indPintar = (ind23h(end)-1:ind23h(end)+21);
plot(th.FECHAHORA(indPintar), th.DEM(indPintar), '.-');
axis tight
figure;
indPintar = (ind25h(end)-1:ind25h(end)+21);
plot(th.FECHAHORA(indPintar), th.DEM(indPintar), '.-');
axis tight

 

th2 = th;
th2.FECHAHORA.Format = 'uuuu-MM-dd''T''HHZZZZ';
th2.FECHAHORANUEVA = th2.FECHAHORA;
th2.FECHAHORANUEVA.TimeZone = '';

 

% Añade hora que falta en día 23 horas
for i=1:length(ind23h)
    ind = ind23h(i) + (i-1);
    taux = th2(1,:);
    taux.FECHAHORA = th2.FECHAHORA(ind);
    taux.FECHAHORANUEVA = th2.FECHAHORANUEVA(ind)+hours(1);
    taux.DEM = mean([th2.DEM(ind), th2.DEM(ind+1)]);
    
    th2 = [th2(1:ind,:); taux; th2(ind+1:end,:)];
%     th2(ind-2:ind+2,:)
end

 

% indMes3 = th2.FECHAHORA.Month == 3;
% th2(indMes3,:)

%% kmeans
% plot idcluster a lo largo del tiempo
figure;
title('Centroides de cada día');
%bar(ttp24h.FECHA,idx);
bar(ttp24h.FECHA(days,:),idx);
ylabel("ID Cluster");
xlabel("Fecha");

% centroide de cada día
%K=3;
%for i = 1:length(idx)
    %matrizCentroidesDias(i,:) = ctrs(idx(i),:);
%end
%figure;
%for i=1:365
    %subplot(12,31,i);
    %plot(matrizCentroidesDias(i,:)');
%end

%se ve fatal con tantos
vectorCentroidesDias =[];
for i = 1:length(idx)
    vectorCentroidesDias =  [vectorCentroidesDias ctrs(idx(i),:)];
end
aux = weekday(thn.FECHAHORA)==1 | weekday(thn.FECHAHORA)==7 ;
auxlabel = thn.FECHAHORA(aux);
auxtable = table(auxlabel);
a = table2array(auxtable);
au = datestr(a,'mm/dd/yy');
%figure;
%plot(auxlabel,vectorCentroidesDias');

%figure;
%bar(auxlabel,vectorCentroidesDias');


