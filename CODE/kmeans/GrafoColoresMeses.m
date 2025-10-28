function [G,H] = GrafoColoresMeses(ttp24h,K,nomInputVars,nomSerie)
    primerYear = ttp24h.FECHA.Year(1,:);
    ultimoYear = ttp24h.FECHA.Year(end,:);
    [G,H]=GrafoEvolucionCluster(ttp24h,K,nomInputVars,nomSerie);     
    title(sprintf('%s Clasificación por estaciones/meses del año',nomSerie));
    coloresEstaciones={'r','b','g','#FF8826'};
    num_nodos=size(G.Nodes);
    colorIdNodo=num2cell(zeros(1,num_nodos(1)));
    i=1;
    for w=primerYear:ultimoYear
        for j=1:K
            vec_diasIdClust=indDias(j,w,ultimoYear,ttp24h,K,nomInputVars);
            summer = sum(ismember(month(vec_diasIdClust),[6:8]));            
            winter = sum(ismember(month(vec_diasIdClust),[1,2,12]));
            spring = sum(ismember(month(vec_diasIdClust),[3:5]));
            fall = sum(ismember(month(vec_diasIdClust),[9:11]));
            [seasonFrec,ind_seasonFrec]=max([summer, winter, spring, fall]);
            colorIdNodo{i}=coloresEstaciones{ind_seasonFrec};
            i=i+1;
        end
    end
    str = 'Rojo = Junio,Julio,Agosto; Azul = Diciembre,Enero,Febrero; Naranja = Septiembre,Octubre,Noviembre;  Verde = Marzo,Abril,Mayo ';
    annotation('textbox','String',str,'FontSize',8,'FitBoxToText','on','Position',[0.3,0.0,0.1,0.1]);
    for i=1:num_nodos
        highlight(H,i,'NodeColor',colorIdNodo{i});
        hold on;
    end
end