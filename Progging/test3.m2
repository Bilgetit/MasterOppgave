listOfResults = {};
listOfSurprises = {};

-- kk = ZZ/32749;
kk = QQ;
RingP3 = kk[x_0..x_3];

pointsMatrix = points -> matrix {{x_0 .. x_3}, points#0, points#1};
lineFromPoints = pointsMatrix -> minors(3, pointsMatrix);

time0 = currentTime();
d = 2;
while currentTime() - time0 < 9*3600 do(  -- wait for 9 hours
    maxNoPoints = ceiling((d+3)*(d+2)*(d+1)/(6*d));
    for noPoints from maxNoPoints to maxNoPoints + 1 do ( -- maxNoPoints to maxNoPoints + 1 for m-chains
        myPoints = apply(noPoints, i -> (
            v := for j in 0..3 list random(kk);
            -- Ensure the point is not the zero vector
            while all(v, x -> x == 0) do (
                v = for j in 0..3 list random(kk)
            );
            v
        )); 
        subsequentPairs = for i from 0 to (#myPoints - 2) list {myPoints#i, myPoints#(i+1)};
        -- subsequentPairs = append(subsequentPairs, {myPoints#0, myPoints#(#myPoints-1)}); -- close the loop
        pointPairs = apply(subsequentPairs, pointsMatrix);
        allLines = apply(pointPairs, lineFromPoints);

        Iz = intersect allLines;
        f = random(d, Iz);

        hf = hilbertFunction(d, RingP3/Iz);
        -- Total number of degree-d monomials in 4 variables over kk is binomial(d+3,3)
        totalForms = binomial(d+3,3);
        numInIz = totalForms - hf; -- number of independent degree-d forms vanishing on Z

        if f == 0 then (
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

        codimension = codim singularLocus ideal f;
        isZero = (f == 0);
        isSingular = (codimension < 4);
        listOfResults = append(listOfResults, (d, noPoints, isZero, isSingular, currentTime() - time0));
        if isSingular then (
            listOfSurprises = append(listOfSurprises, (d, noPoints, isZero, isSingular, currentTime() - time0))
        );
        print("d = " | toString d | ", noPoints = " | toString noPoints | ", isSingular = " | toString isSingular | ", isZero = " | toString isZero | ", numInIz = " | toString numInIz | ", time = " | toString (currentTime() - time0) );
    );
    d = d + 1;
)

time1 = currentTime();
timeTaken = time1 - time0
-- listOfResults
listOfSurprises