function [tr] = TablaVariablesCategArbolClassif(ttp24h,K,year,nomInputVars,timetableFestivos) 
    %K= 12;
    %year =2007;
    [idx, ctrs,sumd] = KMeansYear(ttp24h,K,year,nomInputVars);%aunque esto lo tengo que hacer por cada año
    
    years = ttp24h.FECHA.Year == year;
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    ttp24hYear = ttp24h(years, nomInputVars);
    tr=timetable2table(ttp24hYear);
    %tidx =array2table(idx,'VariableNames',{'IdCluster'});
    vecOrdenClusters=zeros(1,K);
    
    
    vecOrdenClusters=OrdenRespectoMasFrec(ttp24h,K,0,nomInputVars,year); 
    
    OrdenIdxRespectoMasFrec = zeros(size(idx));
    for i=1:size(idx)
        OrdenIdxRespectoMasFrec(i)=vecOrdenClusters(idx(i,1));
    end
    tidx =array2table(OrdenIdxRespectoMasFrec,'VariableNames',{'IdCluster'});

    tDiaSemana=array2table(weekday(tr.FECHA),'VariableNames',{'Dia'});
    diaSemana = string({"Do","Lu","Ma","Mi","Ju","Vi","Sa","Fest"});
    %tDiaSemana=array2table(weekday(ttp24h.FECHA),'VariableNames',{'DiaSemana'});
    %tDiaSemana=table2num(tDiaSemana);
    %tDiaSemana=num2cell(tDiaSemana);
    Meses = string({"Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic"});
    %tMes=array2table(tr.FECHA.Month,'VariableNames',{'Mes'});    
    tDiaSemanacell=string([]);
    vecMes=string([]);
    for i=1:size(tr)
        tDiaSemanacell(i)=diaSemana(tDiaSemana{i,1});
        if(timetableFestivos.FEST(ismember(timetableFestivos.FECHA,tr.FECHA(i)))==1 & (tDiaSemana{i,1}>1 & tDiaSemana{i,1}<7))
            tDiaSemanacell(i)=diaSemana(8);
        end
        
        vecMes(i) = Meses(tr.FECHA.Month(i));
    end
    tMes=array2table(vecMes','VariableNames',{'Mes'}); 
    tFestivo=array2table(timetableFestivos.FEST(ismember(timetableFestivos.FECHA,tr.FECHA)),'VariableNames',{'Festivo'});
    tFestivoPalabra=string([]);
    FestivoONo =string({"Si","No"});
    for i=1:size(tFestivo)
        if (tFestivo{i,1}==1)
            tFestivoPalabra(i,1)=FestivoONo(1);
        else
            tFestivoPalabra(i,1)=FestivoONo(2);
        end
    end
    tFestivoPalabra=array2table(tFestivoPalabra,'VariableNames',{'Festivo'});
    
    tDiaSemana=array2table(tDiaSemanacell','VariableNames',{'Dia'});
    

    estaciones = string({"Invierno","Primavera","Verano","Otoño"});
    tEstacioncell=string([]);
    for i=1:size(tr)    
        yearActual= tr.FECHA(i).Year;
        fechaActual=datetime(tr.FECHA(i),'InputFormat','dd/MM/yyyy');
        if (isbetween(fechaActual,datetime(sprintf("20/03/%d",yearActual),'InputFormat','dd/MM/yyyy'),datetime(sprintf("20/06/%d",yearActual),'InputFormat','dd/MM/yyyy')))
            %primavera
            tEstacioncell(i)=estaciones(2);
        elseif (isbetween(fechaActual,datetime(sprintf("21/06/%d",yearActual),'InputFormat','dd/MM/yyyy'),datetime(sprintf("22/09/%d",yearActual),'InputFormat','dd/MM/yyyy')))
            %verano
            tEstacioncell(i)=estaciones(3);
        elseif (isbetween(fechaActual,datetime(sprintf("23/09/%d",yearActual),'InputFormat','dd/MM/yyyy'),datetime(sprintf("21/12/%d",yearActual),'InputFormat','dd/MM/yyyy')))
            %otoño
            tEstacioncell(i)=estaciones(4);
        elseif (isbetween(fechaActual,datetime(sprintf("22/12/%d",yearActual)),datetime(sprintf("31/12/%d",yearActual))))
            %invierno
            tEstacioncell(i)=estaciones(1);
        elseif (isbetween(fechaActual,datetime(sprintf("01/01/%d",yearActual),'InputFormat','dd/MM/yyyy'),datetime(sprintf("19/03/%d",yearActual),'InputFormat','dd/MM/yyyy')))
            %invierno
            tEstacioncell(i)=estaciones(1);
        end
    end
    tEstaciones=array2table(tEstacioncell','VariableNames',{'Est'});


    tr = [tr tidx tMes tDiaSemana tFestivoPalabra tEstaciones];
end