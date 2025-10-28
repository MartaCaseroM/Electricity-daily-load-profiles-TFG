function creaPerfilesReparto()
% crea todos los perfiles de reparto de todas las series a estudiar y las
% guarda en la carpeta ALMACEN.
rutaOrigen = '..\DATA';
rutaDestino = '..\ALMACEN';

if ~exist(rutaDestino,'dir')
   mkdir(rutaDestino) 
end


% listado de series
nomSeries = {'DEMELEH#P48', 'SEGELEH#TA20', 'SEGELEH#TA21','SEGELEH#TA30A', 'SEGELEH#TA31A','SEGELEH#TA61A'}; 

%para cada serie horaria original crea su serie normalizada y la guarda
for i=1:length(nomSeries)
    nomSerie = nomSeries{i};
    
    %lee datos originales de la serie
    nomFi = sprintf('%s.txt',nomSerie);
    fullFi = fullfile(rutaOrigen,nomFi);
    th = readtable(fullFi);
    th.FECHAHORA = datetime(th{:,1},'inputformat','uuuu-MM-dd''T''HHZZZZ','Timezone','Europe/Madrid','locale','es_ES', 'Format', 'dd/MM/yyyy HH');

    %normaliza la serie horaria original corrigiendo cambio de hora
    thn = normalizaDatosHorarios(th);
    
    %crea el perfil normalizado
    ttp24h = creaPerfilRepartoUnaSerie(nomSerie, thn);
    
    %almacena datos perfiles en el almacen como .mat
    fullFiSalida = fullfile(rutaDestino, sprintf('perfil_%s.mat',nomSerie));
    save(fullFiSalida, 'ttp24h');
    
end


end