function matDistClusters = DistClusters(ctrs,K)
for i=1:K
    for j=1:K
        matDistClusters(i,j) = sum(abs(ctrs(i,:)-ctrs(j,:)));
        if matDistClusters(i,j) == 0
            matDistClusters(i,j) = 100;
        end
    end
    
end
end
