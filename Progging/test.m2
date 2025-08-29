-- printWidth = 60
-- R = QQ[a..d]
-- (a+b+c+d)^4


d = 9;
noPoints = 24;

(d+3)*(d+2)*(d+1)/(6*d);


-- kk = ZZ/101; 
kk = ZZ/32749;
RingP3 = kk[x_0..x_3];

-- Pick noPoints random points in P^3
-- myPoints = {{1,0,0,0}, {0,1,0,0}};
myPoints = apply(noPoints, i -> (
    v := for j in 0..3 list random(kk);
    -- Ensure the point is not the zero vector
    while all(v, x -> x == 0) do (
        v = for j in 0..3 list random(kk)
    );
    v
));

-- M = matrix {{x_0 .. x_3}, myPoints#0, myPoints#1};
pointsMatrix = points -> matrix {{x_0 .. x_3}, points#0, points#1};

subsequentPairs = for i from 0 to (#myPoints - 2) list {myPoints#i, myPoints#(i+1)};

-- Add final pair
subsequentPairs = append(subsequentPairs, {myPoints#0, myPoints#(#myPoints-1)});

pointPairs = apply(subsequentPairs, pointsMatrix);

lineFromPoints = pointsMatrix -> minors(3, pointsMatrix);

allLines = apply(pointPairs, lineFromPoints);

noLines = #allLines;

-- idealLine = minors(3,M);
-- mingens idealLine

-- The union of all lines 
Iz = intersect allLines;
-- Z = variety Iz;

-- Iz == saturate Iz

-- dim Z

-- Iztop = top Iz;

-- (gens Iztop)%(gens Iz) == 0

-- codim singularLocus Iz

-- Pick a random degree d element in Iz
f = random(d, Iz);
Vf = variety ideal f;

codimension = codim singularLocus ideal f;

codimension

isZero = (f == 0)

isSingular = (codimension < 4)

isSmooth(Vf) and not isZero