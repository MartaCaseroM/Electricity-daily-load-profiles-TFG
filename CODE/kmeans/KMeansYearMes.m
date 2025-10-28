function [idx, ctrs,sumd] = KMeansYearMes(ttp24h,K,year,mes,nomInputVars)

years = ttp24h.FECHA.Year == year;
month = ttp24h.FECHA.Month == mes;
X = ttp24h{years & month, nomInputVars};
rng('default'); 
[idx, ctrs,sumd] = kmeans(X,K,'replicates',100,'MaxIter',1000);
end