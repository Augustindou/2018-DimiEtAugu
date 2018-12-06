local


    Tune1 = [stretch(factor: 0.5 [a3 c]) d d stretch(factor:0.5 [d e]) f f stretch(factor:0.5 [f g]) e e stretch(factor:0.5 [d c]) c d]
    Tune2 = [stretch(factor: 0.5 [a3 c]) d d stretch(factor:0.5 [d e]) f f stretch(factor:0.5 [f g]) e e stretch(factor:0.5 [d c]) d]
    Tune3 = [stretch(factor: 0.5 [a3 c]) d d stretch(factor:0.5 [d f]) g g stretch(factor:0.5 [g a]) a#4 a#4 stretch(factor:0.5 [a g]) a d]
    Tune4 = [d e f f g a d d f e e stretch(factor:0.5 [f d]) e]

    Partition = {Flatten [silence(duration:1.0) Tune1 silence(duration:0.3) Tune2 silence(duration:0.3) Tune3 silence(duration:0.3) Tune4 silence(duration:1.0)]}


in
    [partition(stretch(factor:0.25 Partition))]
end