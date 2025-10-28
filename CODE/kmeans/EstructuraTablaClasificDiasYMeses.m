function [EstructTablaDiasMesesConstelaciones] = EstructuraTablaClasificDiasYMeses(DiasConstelacionesEstruct)
    EstructTablaDiasMesesConstelaciones = struct;
    nombreConstelacionesConDias=fieldnames(DiasConstelacionesEstruct);
    %tableConstelacionDescDias = table('Size',[12,7],'VariableTypes',["double","double","double","double","double","double","double"],'VariableNames',{'Lunes','Martes','Miercoles','Jueves','Viernes','Sabado','Domingo'},'RowNames',{'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'}); 
    numGrupConst=size(nombreConstelacionesConDias);
    for numConst=1:numGrupConst    
        nombreConstActual=nombreConstelacionesConDias{numConst};
        DiasConstelaciones=getfield(DiasConstelacionesEstruct,nombreConstelacionesConDias{numConst});
        tableConstelacionDescDias = table('Size',[12,7],'VariableTypes',["double","double","double","double","double","double","double"],'VariableNames',{'Lunes','Martes','Miercoles','Jueves','Viernes','Sabado','Domingo'},'RowNames',{'Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'}); 
        for i=1:7
            for j=1:12
                num_veces_dia_mes = sum((weekday(DiasConstelaciones)== i)& (DiasConstelaciones.Month==j));
                if i==1
                    tableConstelacionDescDias(j,i+6)={num_veces_dia_mes};
                else
                    tableConstelacionDescDias(j,i-1)={num_veces_dia_mes};
                end
            end

        end
        EstructTablaDiasMesesConstelaciones.(nombreConstActual)=tableConstelacionDescDias;
    end
end
