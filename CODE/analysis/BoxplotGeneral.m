function BoxplotGeneral(nomSerie, ttp24h,nomInputVars)
    mp24h = [ttp24h{:,1:end}];
    figure;
    boxplot(mp24h, 'Labels', nomInputVars , 'notch','on', 'orientation','horizontal'); 
    xlabel('Demanda normalizada');
    ylabel('Hora perfil');
    title(sprintf('Perfil demanda eléctrica %s',nomSerie));
    
end
