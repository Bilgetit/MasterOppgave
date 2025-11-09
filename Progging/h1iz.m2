-- Specify degree and number of points
d = 3;
nrPoints = 9; -- Is also the number of lines

kk = ZZ/32749;
kk = QQ;
RingP3 = kk[x_0..x_3];

-- Pick nrPoints random points in P^3
myPoints = apply(nrPoints, i -> (
    v := for j in 0..3 list random(kk);
    -- Ensure the point is not the zero vector
    while all(v, x -> x == 0) do (
        v = for j in 0..3 list random(kk)
    );
    v
));

-- Function to convert two points to a matrix with first row {x_0 .. x_3}
pointsMatrix = points -> matrix {{x_0 .. x_3}, points#0, points#1};

-- Create pairs of subsequent points, and also the pair consisting of the last and first point
subsequentPairs = for i from 0 to (#myPoints - 2) list {myPoints#i, myPoints#(i+1)};
-- Add final pair
-- subsequentPairs = append(subsequentPairs, {myPoints#0, myPoints#(#myPoints-1)});

-- Convert each pair of points to a matrix
pointPairs = apply(subsequentPairs, pointsMatrix);

-- Given a matrix with first row {x_0 .. x_3} and next two rows points, return the ideal of the line through the points
lineFromPoints = pointsMatrix -> minors(3, pointsMatrix);
allLines = apply(pointPairs, lineFromPoints);

-- Intersect the ideals of the lines to get ideal of the union of all lines
Iz = intersect allLines;

F = sheaf(Iz);
H0 = HH^0(F(d))
H1 = HH^1(F(d))
H2 = HH^2(F(d))
H3 = HH^3(F(d))
-- get dimension as vector space over kk
dimH0 = numgens H0
dimH1 = numgens H1
dimH2 = numgens H2
dimH3 = numgens H3