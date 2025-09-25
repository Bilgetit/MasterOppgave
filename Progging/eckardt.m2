d = 4;
noPoints = 14;

kk = ZZ/32749;
RingP3 = kk[x_0..x_3];

randomPoint = i -> (
    v := for j in 0..3 list random(kk);
    -- Ensure the point is not the zero vector
    while all(v, x -> x == 0) do (
        v = for j in 0..3 list random(kk)
    );
    v
);

myPoints = apply(noPoints, randomPoint);

-- Sets the first coordinate of a point to 1, leaves the rest unchanged
setFirstCoordinateToOne = v -> (
    prepend(1, v_{1..3})
);

myPoints = apply(myPoints, setFirstCoordinateToOne);

pointsMatrix = points -> matrix {{x_0 .. x_3}, points#0, points#1};
pairsWithFirstPoint = for i from 1 to (#myPoints - 1) list {myPoints#0, myPoints#i};
pointPairs = apply(pairsWithFirstPoint, pointsMatrix);

lineFromPoints = pointsMatrix -> minors(3, pointsMatrix);
allLines = apply(pointPairs, lineFromPoints);
noLines = #allLines;

Iz = intersect allLines;
f = random(d, Iz);
Vf = variety ideal f;

codimension = codim singularLocus ideal f;
codimension

isZero = (f == 0)

isSingular = (codimension < 4)

isSmooth(Vf) and not isZero

F = sheaf(Iz);
H0 = HH^0(F(d))
H1 = HH^1(F(d))