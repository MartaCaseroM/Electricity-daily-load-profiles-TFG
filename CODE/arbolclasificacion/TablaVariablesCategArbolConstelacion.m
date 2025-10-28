function [trfinal]=TablaVariablesCategArbolConstelacion(gruposConstelaciones,K,ttp24h,nomInputVars,idConstelacion,timetableFestivos)
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    nombreGruposConstelaciones=fieldnames(gruposConstelaciones);
    sizeConstelaciones=size(nombreGruposConstelaciones);
    
    DiasConstelaciones = [];
    
    %DiasConstelacionesEstruct = struct;
    idsConstelaciones=getfield(gruposConstelaciones,nombreGruposConstelaciones{idConstelacion});%los id de las constelaciones
    sizeConstActual=size(idsConstelaciones);
    tr=TablaVariablesCategArbolClassifTodosYears(ttp24h,K,nomInputVars,timetableFestivos);
    for j=1:sizeConstActual(1)
        %j=1;
        idClust=string(idsConstelaciones{j,1});
        num_id=str2num(extractBetween(idClust,"id","-"));
        year_id=str2num(extractAfter(idClust,"-"));
        vecIndDias=indDias(num_id,year_id,ultimoYear,ttp24h,K,nomInputVars);
        
        DiasConstelaciones=[DiasConstelaciones;vecIndDias];        
    end
    DiasConstelaciones = sort(datetime(DiasConstelaciones,'InputFormat', 'dd-mm-yyyy'), 1, 'ascend');
    trfinal=tr(ismember(tr.FECHA,DiasConstelaciones),:); 
    
end