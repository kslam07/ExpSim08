function clas = computeCLa(data, dataTail)
%COMPUTECLA Summary of this function goes here
%   Detailed explanation goes here
    errAngle    = 0.25;
    errV        = 2.5;
    clas = zeros(1, height(data));
    for i = 1:height(data)
        
        dataFit = dataTail(data.AoS(i)-errAngle < dataTail.AoS & ...
            data.AoS(i)+errAngle > dataTail.AoS & ...
            data.V(i)-errV < dataTail.Vinf & ...
            data.V(i)+errV > dataTail.Vinf, :);
        clas(i) = fit(dataFit.AoA, dataFit.CL, "poly1").p1;
    end
end

