function [idx, ctrs,sumd] = KMeansYear(ttp24h,K,year,nomInputVars)

years = ttp24h.FECHA.Year == year;
X = ttp24h{years, nomInputVars};
rng('default'); 
[idx, ctrs,sumd] = kmeans(X,K,'replicates',100,'MaxIter',1000);
end