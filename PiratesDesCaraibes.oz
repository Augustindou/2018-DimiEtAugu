local 

    Tune1 = [a3 c d d d e f f f g e e d c d] %x2
    Tune2 = [a3 c d d d f g g g a a#4 a#4 a g a d]
    Tune3 = [e f f g a d f e e f d e]

    Partition = {Flatten [Tune1 Tune1 Tune2 Tune3]}

in
    [partition(stretch(factor:0.25 Partition))]
end