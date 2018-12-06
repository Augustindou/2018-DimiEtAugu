local


   Tune1a = [e5 e5 silence(duration:1.0) e5 silence(duration:1.0) c5 e5 silence(duration:1.0) g5 silence(duration:3.0) g4 silence(duration:3.0)]
   Tune2a = [c5 silence(duration:2.0) g4 silence(duration:2.0) e4 silence(duration:2.0) a4 silence(duration:1.0) b4 silence(duration:1.0) transpose(semitones:1 [a4]) a4 silence(duration:1.0)]
   Tune3a = [stretch(factor:(4.0/3.0) [g4]) stretch(factor:(4.0/3.0) [e5]) stretch(factor:(4.0/3.0) [g5]) a5 silence(duration:1.0) f5 g5 silence(duration:1.0) e5 silence(duration:1.0) c5 d5 b4 silence(duration:2.0)]
   Tune4a = [silence(duration:2.0) g5 transpose(semitones:1 f5) f5 transpose(semitones:1  d5) silence(duration:1.0) e5 silence(duration:1.0) transpose(semitones:1 g4) a4 c5 silence(duration:1.0) a4 c5 d5]
   Tune5a = [silence(duration:2.0) g5 transpose(semitones:1 f5) f5 transpose(semitones:1  d5) silence(duration:1.0) e5 silence(duration:1.0) c6 silence(duration:1.0) c6 c6 silence(duration:3.0)]
   Tune6a = [silence(duration:2.0) transpose(semitones:1 d5) silence(duration:2.0) d5 silence(duration:2.0) c5 silence(duration:3.0)]
	     






   Partition = {Flatten [Tune1a Tune2a Tune3a Tune4a Tune5a Tune4a Tune6a]}
in
   [partition([duration(seconds:10.0 Partition)])]
end