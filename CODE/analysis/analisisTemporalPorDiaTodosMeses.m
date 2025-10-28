function analisisTemporalPorDiaTodosMeses(nomSerie,ttp24h)

figure;
sgtitle(sprintf('Perfiles Clasificados por día y mes - Tarifa: %s',nomSerie));
for i=1:7
    subplot(2,4,i);
    analisisTemporalDia(nomSerie,i,ttp24h);
end
end