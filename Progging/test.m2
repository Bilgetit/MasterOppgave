-- Specify degree and number of points
d = 3;
nrPoints = 7; -- Is also the number of lines

-- Gives maximum number of lines on a degree d surface in P^3
-- floor((d+3)*(d+2)*(d+1)/(6*d))


-- kk = ZZ/101; 
-- kk = ZZ/32749;
kk = QQ;
RingP3 = kk[x,y,z,w];

-- Pick nrPoints random points in P^3
myPoints = apply(nrPoints, i -> (
    v := for j in 0..3 list random(kk);
    -- Ensure the point is not the zero vector
    while all(v, x -> x == 0) do (
        v = for j in 0..3 list random(kk)
    );
    v
));

-- myPoints = {{1,0,0,0}, {0,1,0,0}, {0,0,1,0}, {0,0,0,1}, {1,1,1,1}};
-- M = matrix {{x_0 .. x_3}, myPoints#0, myPoints#1};

-- Function to convert two points to a matrix with first row {x_0 .. x_3}
pointsMatrix = points -> matrix {{x,y,z,w}, points#0, points#1};

-- Create pairs of subsequent points, and also the pair consisting of the last and first point
subsequentPairs = for i from 0 to (#myPoints - 2) list {myPoints#i, myPoints#(i+1)};
-- Add final pair
-- subsequentPairs = append(subsequentPairs, {myPoints#0, myPoints#(#myPoints-1)});

-- Convert each pair of points to a matrix
pointPairs = apply(subsequentPairs, pointsMatrix);

-- Given a matrix with first row {x_0 .. x_3} and next two rows points, return the ideal of the line through the points
lineFromPoints = pointsMatrix -> minors(3, pointsMatrix);
allLines = apply(pointPairs, lineFromPoints);

-- noLines = #allLines;

-- idealLine = minors(3,M);
-- mingens idealLine

-- Intersect the ideals of the lines to get ideal of the union of all lines
Iz = intersect allLines;
-- mingens Iz
-- Z = variety Iz;

-- Iz == saturate Iz

-- dim Z

-- Iztop = top Iz;

-- (gens Iztop)%(gens Iz) == 0

-- codim singularLocus Iz

-- Pick a random degree d element in Iz
f = random(d, Iz);


if f == 0 then (
    print("Picked zero polynomial, trying to find a nonzero element in Iz of degree d...");
    hf = hilbertFunction(d, RingP3/Iz);
    -- Total number of degree-d monomials in 4 variables over kk is binomial(d+3,3)
    totalForms = binomial(d+3,3);
    numInIz = totalForms - hf; -- number of independent degree-d forms vanishing on Z
    if numInIz > 0 then (
        tries = 0;
        maxAttempts = 100; -- abort with an error if we cannot find a nonzero element
        while f == 0 do (
            f = random(d, Iz);
            tries = tries + 1;
            if tries > maxAttempts then error ("Could not find nonzero element of degree " | toString d | " in Iz after " | toString maxAttempts | " attempts");
        );
    );
);

-- Create the variety defined by f
Vf = variety ideal f;

-- Check if the surface is smooth and not the zero polynomial
codimension = codim singularLocus ideal f;
isZero = (f == 0)
isSingular = (codimension < 4)


