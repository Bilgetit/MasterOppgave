-- printWidth = 60
-- R = QQ[a..d]
-- (a+b+c+d)^4

noPoints = 4;
d = 5;

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

-- idealOfPoint = myPoint -> ideal (for i in 0..((length myPoint)-1) list x_i - myPoint#i);
-- myPoints = for i in 0..((length myPoints)-1) list idealOfPoint myPoints#i;
-- pointsIdeal = intersect myPoints;

-- M = matrix {{x_0 .. x_3}, myPoints#0, myPoints#1};
pointsMatrix = points -> matrix {{x_0 .. x_3}, points#0, points#1};

subsequentPairs = for i from 0 to (#myPoints - 2) list {myPoints#i, myPoints#(i+1)};

pointPairs = apply(subsequentPairs, pointsMatrix);

LineFromPoints = pointsMatrix -> minors(3, pointsMatrix);

allLines = apply(pointPairs, LineFromPoints);

-- idealLine = minors(3,M);
-- mingens idealLine


-- Generate all ordered pairs of points
-- TODO: This gives lines between all points, we only want "edges"
-- pointPairs = subsets(myPoints, 2);

-- The union of all lines (as a subscheme)
Iz = intersect allLines;
-- Iz = idealLine;

-- Z = variety Iz;

-- Iz == saturate Iz

-- dim Z

-- Iztop = top Iz;

-- (gens Iztop)%(gens Iz) == 0

codim singularLocus Iz

-- Pick a random degree d element in Iz
f = random(d, Iz);

V = variety ideal f
codim singularLocus ideal f

-- Step 6: Check smoothness outside the base locus

-- Compute the partial derivatives
df = for v in {x_0, x_1, x_2} list diff(v, f);

-- Form the Jacobian ideal (f and its partials)
J = ideal(f) + ideal df;

-- singularLocus(J)

isSmoothOutsideBase = (saturate(J, Iz) == ideal(1_RingP3));


-- Compute the base locus as a subscheme
baseLocus = Proj(RingP3/Iz);

-- Compute the singular locus (the subscheme where all partials vanish)
singLocus = Proj(RingP3/J);

-- Check if the singular locus is empty
isSingularContained = isSubset(radical Iz, radical J);

isSingularContained

isSmoothOutsideBase


singLocus = singularLocus(RingP3/f);
baseLocus = singularLocus(Iz);
isSingularContained = isSubset(singLocus, Iz)