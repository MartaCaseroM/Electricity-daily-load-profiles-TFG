function [th2] = normalizaDatosHorarios(th) 
%realiza la corrección de los cambios de hora    

    % detectamos cambios de hora
    ind23h = find(diff(th.FECHAHORA.Hour)==2); % meter una hora despues de este valor
    ind25h = find(diff(th.FECHAHORA.Hour)==0); % Calcular la media de este valor con el siguiente

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
    end

    % Elimina hora repetida en día 25 horas
    for i=1:length(ind25h)
        ind = ind25h(i) + 1; 
        taux25h = th2(1,:);
        taux25h.FECHAHORA = th2.FECHAHORA(ind);
        taux25h.FECHAHORANUEVA = th2.FECHAHORANUEVA(ind);
        taux25h.DEM = mean([th2.DEM(ind), th2.DEM(ind+1)]);
        th2 = [th2(1:ind-1,:);taux25h;th2(ind+2:end,:)];
    end
    th2.FECHAHORA=[];
    th2.Properties.VariableNames{'FECHAHORANUEVA'}='FECHAHORA';
end
