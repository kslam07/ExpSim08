
tailOffPath = "./DATA/TailOffData.xlsx";
data = readtable(tailOffPath, "sheet", "AoS variations");

v = [20];
beta = -10:10;
clas = [];
figure(1);
for i = 1:length(beta)
    for j = 1:length(v)
        datai = data(v(j)-0.1<data.Vinf & data.Vinf<v(j)+0.1 & beta(i)-0.1 < data.AoS & ...
            beta(i)+0.1 > data.AoS, :);
        figure(1)
        plot(datai.AoA, datai.CL)
        clas = cat(1, clas, fit(datai.AoA, datai.CL, "poly1").p1);
        hold on;
    end
end