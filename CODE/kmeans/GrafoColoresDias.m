function [G,H] = GrafoColoresDias(ttp24h,K,nomInputVars,nomSerie,timetableFestivos)
primerYear = ttp24h.FECHA.Year(1,:);
ultimoYear = ttp24h.FECHA.Year(end,:);
[G,H]=GrafoEvolucionCluster(ttp24h,K,nomInputVars,nomSerie);     
title(sprintf('%s Clasificación por días de la semana',nomSerie));
coloresDias={'b','r','r','r','g','y','#FF8826','#BD2DFF'};%naranja,morado
num_nodos=size(G.Nodes);
colorIdNodo=num2cell(zeros(1,num_nodos(1)));
i=1;
for w=primerYear:ultimoYear
    for j=1:K
        vec_diasIdClust=indDias(j,w,ultimoYear,ttp24h,K,nomInputVars);
        festivo = sum(timetableFestivos.FEST(ismember(timetableFestivos.FECHA,vec_diasIdClust)));  
        lunesNoFestivo = size(find(weekday(vec_diasIdClust)==2 & timetableFestivos.FEST(ismember(timetableFestivos.FECHA,vec_diasIdClust))==0));
        martesNoFestivo = size(find(weekday(vec_diasIdClust)==3 & timetableFestivos.FEST(ismember(timetableFestivos.FECHA,vec_diasIdClust))==0));
        miercolesNoFestivo = size(find(weekday(vec_diasIdClust)==4 & timetableFestivos.FEST(ismember(timetableFestivos.FECHA,vec_diasIdClust))==0));
        juevesNoFestivo = size(find(weekday(vec_diasIdClust)==5 & timetableFestivos.FEST(ismember(timetableFestivos.FECHA,vec_diasIdClust))==0));
        viernesNoFestivo = size(find(weekday(vec_diasIdClust)==6 & timetableFestivos.FEST(ismember(timetableFestivos.FECHA,vec_diasIdClust))==0));
        sabado = sum(ismember(weekday(vec_diasIdClust),7)); 
        domingo = sum(ismember(weekday(vec_diasIdClust),1));        
        [diasFrec,ind_diasFrec]=max([lunesNoFestivo(1), martesNoFestivo(1), miercolesNoFestivo(1), juevesNoFestivo(1), viernesNoFestivo(1), sabado, domingo, festivo]);
        colorIdNodo{i}=coloresDias{ind_diasFrec};
        i=i+1;
    end
end
str = 'Azul = Lunes;  Rojo = Martes, Miércoles, Jueves;  Verde = Viernes;  Amarillo = Sábado;  Naranja = Domingo;  Morado = Festivo';
annotation('textbox','String',str,'FontSize',8,'FitBoxToText','on','Position',[0.3,0.0,0.1,0.1]);
for i=1:num_nodos
    highlight(H,i,'NodeColor',colorIdNodo{i});
    hold on;
end
end