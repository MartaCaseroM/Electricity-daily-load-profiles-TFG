function [DiasConstelacionesEstruct]=EstructuraDiasConstelaciones(gruposConstelaciones,K,ttp24h,nomInputVars)
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    nombreGruposConstelaciones=fieldnames(gruposConstelaciones);
    sizeConstelaciones=size(nombreGruposConstelaciones);
    DiasConstelaciones = [];
    MatConstelaciones= [];
    DiasConstelacionesEstruct = struct;
    for i=1:sizeConstelaciones(1)
        idsConstelaciones=getfield(gruposConstelaciones,nombreGruposConstelaciones{i});%los id de las constelaciones
        sizeConstActual=size(idsConstelaciones);
        for j=1:sizeConstActual(1)
            idClust=string(idsConstelaciones{j,1});
            num_id=str2num(extractBetween(idClust,"id","-"));
            year_id=str2num(extractAfter(idClust,"-"));
            vecIndDias=indDias(num_id,year_id,ultimoYear,ttp24h,K,nomInputVars);
            DiasConstelaciones=[DiasConstelaciones;vecIndDias];        
        end

        DiasConstelacionesEstruct.(sprintf(nombreGruposConstelaciones{i}))=DiasConstelaciones;

        DiasConstelaciones=[];
    end
end