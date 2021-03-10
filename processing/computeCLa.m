function clas = computeCLa(data, dataTail)
%COMPUTECLA Summary of this function goes here
%   Detailed explanation goes here
    err = 0.1;
    clas = zeros(1, height(data));
    for i = 1:height(data)
        
        dataFit = dataTail(data.AoS(i)-err<dataTail.AoS & ...
            data.AoS(i)+err>dataTail.AoS & data.V(i)-err<dataTail.Vinf & ...
            data.V(i)+err>dataTail.Vinf,:);
        clas(i) = fit(dataFit.AoA, dataFit.CL, "poly1").p1;
    end
end

