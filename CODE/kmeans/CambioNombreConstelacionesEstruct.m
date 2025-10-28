function [EstructTablaDiasMesesConstelaciones, DiasConstelacionesEstruct, gruposConstelaciones] = CambioNombreConstelacionesEstruct(EstructTablaDiasMesesConstelaciones,DiasConstelacionesEstruct,gruposConstelaciones)
    nombreConstelacionesConDias=fieldnames(DiasConstelacionesEstruct);
    for i=1:size(nombreConstelacionesConDias)
        valueField_MatrizClasifConst= getfield(EstructTablaDiasMesesConstelaciones,nombreConstelacionesConDias{i});
        EstructTablaDiasMesesConstelaciones = rmfield(EstructTablaDiasMesesConstelaciones,nombreConstelacionesConDias{i});
        EstructTablaDiasMesesConstelaciones.(sprintf('constelacion%d',i)) = valueField_MatrizClasifConst;

        valueField_DiasConst= getfield(DiasConstelacionesEstruct,nombreConstelacionesConDias{i});
        DiasConstelacionesEstruct = rmfield(DiasConstelacionesEstruct,nombreConstelacionesConDias{i});
        DiasConstelacionesEstruct.(sprintf('constelacion%d',i)) = valueField_DiasConst;

        valueField_IdClustersConst= getfield(gruposConstelaciones,nombreConstelacionesConDias{i});
        gruposConstelaciones = rmfield(gruposConstelaciones,nombreConstelacionesConDias{i});
        gruposConstelaciones.(sprintf('constelacion%d',i)) = valueField_IdClustersConst;    
    end
