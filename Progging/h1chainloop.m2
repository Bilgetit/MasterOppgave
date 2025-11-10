-- listOfResults = {};
-- listOfSurprises = {};

kk = ZZ/32749;
RingP3 = kk[x_0..x_3];

pointsMatrix = points -> matrix {{x_0 .. x_3}, points#0, points#1};
lineFromPoints = pointsMatrix -> minors(3, pointsMatrix);

listOfIz = {};

time0 = currentTime();
d = 2;
while currentTime() - time0 < 10*60 do(  -- wait for 10 minutes
    maxNoLines = (binomial(d+3, 3) - 1)/d;
    print(numeric(maxNoLines));
    maxNoPoints = ceiling(maxNoLines)+1;
    print(maxNoPoints);
    for noPoints from maxNoPoints to maxNoPoints + 5 do (
        M = binomial(d+3, 3) - (noPoints-1) * d - 1;
        -- get or create a single Iz for this number of points
        getOrMakeIz = np -> (
            -- search cache
            for pair in listOfIz do (
                if pair#0 == np then (
                    return pair#1
                )
            );
            -- not found: generate one random m-gon and store its ideal
            myPoints = apply(np, i -> (
                v := for j in 0..3 list random(kk);
                -- Ensure the point is not the zero vector
                while all(v, x -> x == 0) do (
                    v = for j in 0..3 list random(kk)
                );
                v
            ));
            subsequentPairs = for i from 0 to (#myPoints - 2) list {myPoints#i, myPoints#(i+1)};
            -- subsequentPairs = append(subsequentPairs, {myPoints#0, myPoints#(#myPoints-1)});
            pointPairs = apply(subsequentPairs, pointsMatrix);
            allLines = apply(pointPairs, lineFromPoints);
            IzNew = intersect allLines;
            listOfIz = append(listOfIz, (np, IzNew));
            return IzNew
        );

        Iz = getOrMakeIz(noPoints);
        F = sheaf(Iz);
        H1 = HH^1(F(d));
        numGens = numgens H1;
        -- listOfResults = append(listOfResults, (d, noPoints, isH1Zero, dimH1, currentTime() - time0));
        -- if not isH1Zero then (
        --     listOfSurprises = append(listOfSurprises, (d, noPoints, isH1Zero))
        -- );
        print("d = " | toString d | ", noLines = " | toString (noPoints-1) | ", difference = " | toString (numGens + M) | ", numGensH1 = " | toString numGens | ", time = " | toString (currentTime() - time0) );
    );
    d = d + 1;
)

time1 = currentTime();
timeTaken = time1 - time0
-- listOfResults
-- listOfSurprises