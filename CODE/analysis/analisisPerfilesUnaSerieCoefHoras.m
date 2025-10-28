function analisisPerfilesUnaSerieCoefHoras(nomSerie,ttp24h)
%carga de carpeta almacen la tabla ttp24h de la serie elegida y muestra en
%plot, los perfiles 

rutaAlmacen = '..\ALMACEN';
%nomSerie = 'DEMELEH#P48';

% cargamos perfil de la serie
%nomFiCargar = sprintf('perfil_%s.mat', nomSerie);
%rutaNomFiCargar = fullfile(rutaAlmacen, nomFiCargar);
%infomat = load (rutaNomFiCargar);
%ttp24h = infomat.ttp24h;

% ejemplo mostrar los datos

figure;
stackedplot(ttp24h(:,1:13));
title(sprintf('Evolución Temporal Coeficientes de Perfiles de demanda - Tarifa %s',nomSerie));2


figure;
stackedplot(ttp24h(:,14:end));
title(sprintf('Evolución Temporal Coeficientes de Perfiles de demanda - Tarifa %s',nomSerie));2



end