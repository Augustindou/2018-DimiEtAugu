local 
    Tune1 = [e c]
    Tune2 = [stretch(factor:0.5 [d])]
    Tune3 = [e f]
    Tune4 = [stretch(factor:0.5 [g])]
    Tune5 = [a]
    %Tune4
    %Tune5
    Tune6 = [stretch(factor:0.5 [c#5])]
    Tune7 = [stretch(factor:2.0 [e])]
    Tune8 = [stretch(factor:0.5 [e a g a])]
    Tune9 = [stretch(factor:2.0 [b])]
    Tune10 = [stretch(factor:0.5 [b b a g])]
    Tune11 = [stretch(factor:2.0 [a])]
    Tune12 = [silence(duration:1.0)]
    Tune13 = [stretch(factor:0.5 [a f])]
    Tune14 = [e]
    Tune15 = [stretch(factor:0.5 [f g])]
    Tune16 = [a]
    Tune17 = [a b]
    Tune18 = [stretch(factor:2.0 [g])]
    Tune19 = [g]
    Tune20 = [stretch(factor:0.5 [g f])]
    Tune21 = [stretch(factor:1.5 [e])]
    Tune22 = [g b]
    Tune23 = [stretch(factor:0.5 [f g])]
    Tune24 = [stretch(factor:3.0 [e])]
    Tune25 = [f]
    Tune26 = [stretch(factor:0.5 [e])]
    Tune27 = [stretch(factor:2.0 [e])]
    Tune28 = [stretch(factor:0.5 [f e f g])]

    Partition = {Flatten [Tune1 Tune2 Tune3 Tune4 Tune5 Tune4 Tune5 Tune6 Tune7 Tune8 Tune9 Tune10 Tune11 Tune12 Tune13 Tune14 Tune15 Tune16 Tune17 Tune18 Tune19 Tune20 Tune21 Tune22 Tune23 Tune24 Tune25 Tune26 Tune27 Tune28]}
in
    [partition(stretch(factor:0.5 Partition))]
end