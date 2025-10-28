function analisisTemporalPorDiaTodosMesesYear(nomSerie,ttp24h,year,nomInputVars)

years = ttp24h.FECHA.Year == year;
ttp24h = ttp24h(years, nomInputVars);
figure;
sgtitle(sprintf('Perfiles Clasificados por día y mes - Tarifa: %s año %d',nomSerie,year));
for i=1:7
    subplot(2,4,i);
    analisisTemporalDia(nomSerie,i,ttp24h);
end
end