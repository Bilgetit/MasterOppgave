-- Step 1: Define the ring and parameters
kk = ZZ/32749;
RingP3 = kk[x_0..x_3];
d = 2;  -- Degree of the hypersurface
nrPoints = 4;

-- Step 2 and 3: Generate random points and create pairs of subsequent points
-- Function for generating i random points in P^3
randomPoints = i -> (
    v := for j in 0..3 list random(kk);
    -- Ensure the point is not zero
    while all(v, x -> x == 0) do (
        v = for j in 0..3 list random(kk)
    );
    v
)
-- Pick nrPoints random points in P^3
myPoints = apply(nrPoints, randomPoints);
-- Create pairs of subsequent points, and also the pair consisting of the last and first point
subsequentPairs = for i from 0 to (#myPoints - 2) list {myPoints#i, myPoints#(i+1)};
-- Add final pair
subsequentPairs = append(subsequentPairs, {myPoints#0, myPoints#(#myPoints-1)});

-- Step 3: Generate matrices from point pairs
-- Function to convert two points to a matrix with first row {x_0 .. x_3}
pointsToMatrix = points -> matrix {{x_0 .. x_3}, points#0, points#1};
-- Convert each pair of points to a matrix
pointsMatrix = apply(subsequentPairs, pointsToMatrix);

-- Step 4: Get the ideals of the lines
-- Given a matrix with first row {x_0 .. x_3} and next two rows points, return the ideal of the line through the points
lineFromPoints = pointsMatrix -> minors(3, pointsMatrix);
allLines = apply(pointsMatrix, lineFromPoints);

-- Step 5: Create the ideal of the union of all lines
-- Intersect the ideals of the lines to get ideal of the union of all lines
Iz = intersect allLines;

-- Step 6: Pick a degree d element in Iz, which defines a surface containing all the lines, and check properties
-- Pick a random degree d element in Iz
f = random(d, Iz);
-- Create the variety defined by f
Vf = variety ideal f;

-- Check if the surface is smooth and not the zero polynomial
codimension = codim singularLocus ideal f;
isZero = (f == 0)
isSingular = (codimension < 4)
isSmooth(Vf) and not isZero