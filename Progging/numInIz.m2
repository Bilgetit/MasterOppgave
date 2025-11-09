kk = ZZ/32749;
-- kk = QQ;
RingP3 = kk[x_0..x_3];
d = 10;
nrOfPoints = 28;

pointsMatrix = points -> matrix {{x_0 .. x_3}, points#0, points#1};
lineFromPoints = pointsMatrix -> minors(3, pointsMatrix);

myPoints = apply(nrOfPoints, i -> (
    v := for j in 0..3 list random(kk);
    -- Ensure the point is not the zero vector
    while all(v, x -> x == 0) do (
        v = for j in 0..3 list random(kk)
    );
    v
)); 
subsequentPairs = for i from 0 to (#myPoints - 2) list {myPoints#i, myPoints#(i+1)};
subsequentPairs = append(subsequentPairs, {myPoints#0, myPoints#(#myPoints-1)}); -- close the loop
pointPairs = apply(subsequentPairs, pointsMatrix);
allLines = apply(pointPairs, lineFromPoints);

Iz = intersect allLines;
f = random(d, Iz);

time0 = currentTime();
hf = hilbertFunction(d, RingP3/Iz);
-- Total number of degree-d monomials in 4 variables over kk is binomial(d+3,3)
totalForms = binomial(d+3,3);
numInIz = totalForms - hf; -- number of independent degree-d forms vanishing on Z

time1 = currentTime();
timeTaken = time1 - time0