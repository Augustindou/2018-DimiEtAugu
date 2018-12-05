local 
    Tune1 = [stretch(factor:0.5 [e5 d#5 e5 d#5 e5 b d5 c5])] % x 0.5
    Tune2 = [stretch(factor:1.5 [a])] % x 1.5
    Tune3 = [stretch(factor:0.5 [c e a])] % x 0.5
    Tune4 = [stretch(factor:1.5 [b])] % x 1.5
    Tune5 = [stretch(factor:0.5 [e g#4 b])] % x 0.5
    Tune6 = [stretch(factor:1.5 [c5])] % x 1.5
    Tune7 = [stretch(factor:0.5 [e e5 d#5 e5 d#5 e5 b e5 c5])] % x 0.5
    Tune8 = [stretch(factor:1.5 [a])] % x 1.5
    Tune9 = [stretch(factor:0.5 [c e a])] % x 0.5
    Tune10 = [stretch(factor:1.5 [b])] % x 1.5
    Tune11 = [stretch(factor:0.5 [e c5 b])] % x 0.5 
    Tune12 = [stretch(factor:1.5 [a])] % x 1.5 
    Tune13 = [stretch(factor:0.5 [b c5 d5])] % x 0.5 
    Tune14 = [stretch(factor:1.5 [e5])] % x 1.5
    Tune15 = [stretch(factor:0.5 [g f5 e5])] % x 0.5
    Tune16 = [stretch(factor:1.5 [d5])] % x 1.5
    Tune17 = [stretch(factor:0.5 [f e5 d5])] % x 0.5 
    
    Partition = {Flatten [Tune1 Tune2 Tune3 Tune4 Tune5 Tune6 Tune7 Tune8 Tune9 Tune10 Tune11 Tune12 Tune13 Tune14 Tune15 Tune16 Tune17]}
in 
    [partition(stretch(factor:0.5 Partition))]
end