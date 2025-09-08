listOfResults = {};
listOfSurprises = {};

kk = ZZ/32749;
RingP3 = kk[x_0..x_3];

pointsMatrix = points -> matrix {{x_0 .. x_3}, points#0, points#1};

lineFromPoints = pointsMatrix -> minors(3, pointsMatrix);

time0 = currentTime();
for d from 3 to 7 do (
    maxNoPoints = ceiling((d+3)*(d+2)*(d+1)/(6*d));
    for noPoints from maxNoPoints - 1 to maxNoPoints do (
        myPoints = apply(noPoints, i -> (
            v := for j in 0..3 list random(kk);
            -- Ensure the point is not the zero vector
            while all(v, x -> x == 0) do (
                v = for j in 0..3 list random(kk)
            );
            v
        )); 
        subsequentPairs = for i from 0 to (#myPoints - 2) list {myPoints#i, myPoints#(i+1)};
        subsequentPairs = append(subsequentPairs, {myPoints#0, myPoints#(#myPoints-1)});
        pointPairs = apply(subsequentPairs, pointsMatrix);
        allLines = apply(pointPairs, lineFromPoints);

        Iz = intersect allLines;
        f = random(d, Iz);
        Vf = variety ideal f;

        codimension = codim singularLocus ideal f;
        isZero = (f == 0);
        isSingular = (codimension < 4);
        listOfResults = append(listOfResults, (d, noPoints, isZero, isSingular));
        if isSingular then (
            listOfSurprises = append(listOfSurprises, (d, noPoints, isZero, isSingular))
        );
    )
)
time1 = currentTime();
timeTaken = time1 - time0
listOfResults


listOfSurprises


