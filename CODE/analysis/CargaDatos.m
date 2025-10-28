function [ttp24h, timetableFestivos] = CargaDatos(nomSerie, nomInputVars)
%obtención de la tabla de los perfiles de demanda normalizados
%correspondiente a la tarifa/demanda nomSerie
    
addpath 'C:\Users\Usuario\Documents\ICAI\TFG\DATOS\DATOS\ALMACEN';
infomat = load(sprintf('perfil_%s.mat',nomSerie));    
infomat.ttp24h = renamevars(infomat.ttp24h,{'PERFILH0' 'PERFILH1' 'PERFILH2' 'PERFILH3' 'PERFILH4' 'PERFILH5' 'PERFILH6' 'PERFILH7' 'PERFILH8' 'PERFILH9' 'PERFILH10' 'PERFILH11' 'PERFILH12' 'PERFILH13' 'PERFILH14' 'PERFILH15' 'PERFILH16' 'PERFILH17' 'PERFILH18' 'PERFILH19' 'PERFILH20' 'PERFILH21' 'PERFILH22' 'PERFILH23'},nomInputVars);
ttp24h=infomat.ttp24h;

%generación tabla de festivos
addpath 'C:\Users\Usuario\Documents\ICAI\TFG\DATOS\DATOS\DATA';
tablaFestivos = readtable('FESTIVOS_ES.csv');
timetableFestivos = table2timetable(tablaFestivos,'RowTimes','FECHA'); 
timetableFestivos.FECHA.Format = 'dd/MM/yyyy';
    

end