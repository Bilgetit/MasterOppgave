-- printWidth = 60
-- R = QQ[a..d]
-- (a+b+c+d)^4

needsPackage "FastMinors";

-- Step 1: Define the field and projective space
noPoints = 2;
d = 8;

-- Step 2: Definitions

-- define the finite field
-- kk = ZZ/101; 
kk = ZZ/32749;

-- Define projective 3-space (for example, P^3) over k
-- P3 = Proj(kk[x_0..x_2]);
-- R = ring P3;
RingP3 = kk[x_0..x_2];

-- Step 3: Pick random points, and construct lines through the points

-- Pick 4 random points in P^3
points = apply(noPoints, i ->  random(RingP3^1, RingP3^{-1}));

-- Generate all unordered pairs of points
-- TODO: This gives lines between all points, we only want "edges"
pointPairs = subsets(points, 2);


-- -- Alt: Try Eckhardt point construction

-- -- Pick a fixed point in P^3
-- P0 = random(R^1, R^{-1});

-- -- Pick the other points
-- otherPoints = apply(noPoints-1, i -> random(R^1, R^{-1}));

-- -- Make all pairs (P0, Pi)
-- pointPairs = apply(otherPoints, Pi -> {P0, Pi});

-- For each pair, compute the ideal of the line through them
allLines = apply(pointPairs, p -> intersect(ideal p#0, ideal p#1));


-- Step 4: Form the union of all lines

-- The union of all lines (as a subscheme)
Iz = intersect allLines;

Z = variety Iz;

-- Step 5: Pick a random hypersurface containing all lines

-- Pick a random degree d element in Iz
f = random(d, Iz);

singularLocus Proj(RingP3/f)

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