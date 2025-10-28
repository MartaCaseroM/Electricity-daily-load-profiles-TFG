function Coeff1y2ComponentePrincipalPCATodosYears(ttp24h,nomInputVars,nomSerie)
    
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    %figure;
    %hold on;
    
    colores={[1 0 0],[0 0 1],[0 0 0],[0.9290 0.6940 0.1250],[1 1 0],[1 0 1],[0 1 1],[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.6350 0.0780 0.1840],[1 0.5 0.8],[0.6 0.6 0.9],[0.6 0.5 1]};
    figure;
    hold on;
    numPCShow = 2; 
    subplot(2,1,1);
    hold on;
    for j=primerYear:ultimoYear
        years = ttp24h.FECHA.Year == j;
        X = ttp24h{years, nomInputVars};       
        [loading, score, latent,~, explained, mu] = pca(X);
        
        bar(loading(:,1),'FaceColor',colores{j-(primerYear-1)},'FaceAlpha',1.0,'EdgeColor',colores{j-(primerYear-1)});
        xlabel('Input'); ylabel('Loading'); title (sprintf('Coeff. PC %d',1)); 
    end
    subplot(2,1,2);
    hold on;
    for j=primerYear:ultimoYear
        years = ttp24h.FECHA.Year == j;
        X = ttp24h{years, nomInputVars};       
        [loading, score, latent,~, explained, mu] = pca(X);
        
        bar(loading(:,2),'FaceColor',colores{j-(primerYear-1)},'FaceAlpha',1.0,'EdgeColor',colores{j-(primerYear-1)});
        xlabel('Input'); ylabel('Loading'); title (sprintf('Coeff. PC %d',2)); 
    end
    legend(string(primerYear:ultimoYear));
    
    evolucionPC1=zeros(ultimoYear-primerYear+1,24*(ultimoYear-primerYear+1));
    evolucionPC2=zeros(ultimoYear-primerYear+1,24*(ultimoYear-primerYear+1));
    for j=1:(ultimoYear-primerYear+1)
        years = ttp24h.FECHA.Year == j+primerYear-1;
        X = ttp24h{years, nomInputVars};       
        [loading, score, latent,~, explained, mu] = pca(X);
        evolucionPC1(j,(j*24)-23:j*24)= loading(:,1)';
        evolucionPC2(j,(j*24)-23:j*24)= loading(:,2)';
        
    end
    
    figure;
    subplot(2,1,1);
    hold on;
    for j=1:(ultimoYear-primerYear+1)
        bar(evolucionPC1(j,:));
    end
    ylabel('Pesos');
    title('Evolución temporal coeficiente 1ºcomponente principal');
    h = gca;
    %h.XTick=1:24;
    h.XTick=1:24*(ultimoYear-primerYear+1);
    %h.XTickLabel = [string(0:23)];
    h.XTickLabel = string(repmat(0:23,1,24*(ultimoYear-primerYear+1)));
    h.FontSize =5;
    xtickangle(90);
    subplot(2,1,2);
    hold on;
    for j=1:(ultimoYear-primerYear+1)
        bar(evolucionPC2(j,:));
    end
    ylabel('Pesos');
    title('Evolución temporal coeficiente 2ºcomponente principal');
    h = gca;
    %h.XTick=1:24;
    h.XTick=1:24*(ultimoYear-primerYear+1);
    %h.XTickLabel = [string(0:23)];
    h.XTickLabel = string(repmat(0:23,1,24*(ultimoYear-primerYear+1)));
    h.FontSize =5;
    xtickangle(90);
    linkaxes;
    legend([string(primerYear:ultimoYear)]);
    
end