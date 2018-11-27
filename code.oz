local
   % See project statement for API details.
   [Project] = {Link ['Project2018.ozf']}
   Time = {Link ['x-oz://boot/Time']}.1.getReferenceTime

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %

   fun {NoteToExtended Note}
      case Note
      of Name#Octave then
         note(name:Name octave:Octave sharp:true duration:1.0 instrument:none)
      [] Atom then
         case {AtomToString Atom}
         of [_] then
            note(name:Atom octave:4 sharp:false duration:1.0 instrument:none)
         [] [N O] then
            note(name:{StringToAtom [N]} octave:{StringToInt [O]} sharp:false duration:1.0 instrument: none)
         end
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun {ChordToExtended Chord}
      0
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Fonction qui transforme une note en "qqch"(duration:D height:H Instrument:I)

   fun {NoteToSample Note D I}
      case Note of silence then silence(duration:D)
      else
         local X Y in
            X = {NoteToExtended Note}
            case X.name#X.sharp
            of a#false then Y=0
            [] a#true then Y=1
            [] b#false then Y=2
            [] c#false then Y=~9
            [] c#true then Y=~8
            [] d#false then Y=~7
            [] d#true then Y=~6
            [] e#false then Y=~5
            [] f#false then Y=~4
            [] f#true then Y=~3
            [] g#false then Y=~2
            [] g#true then Y=~1
            end

            sample(duration:D height:(X.octave-4)*12+Y instrument:I)
         end
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Fonction Stretch

   fun {Stretch F Sample}
      case Sample
      of nil then nil
      [] H|T then {Stretch F H}|{Stretch F T}
      [] sample(duration:D height:H instrument:I) then sample(duration:D*F height:H instrument:I)
      [] silence(duration:D) then silence(duration:D*F)
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Fonction Duration

   fun {Duration D Sample}
      fun{TotalDuration Sample Acc}
         case Sample
         of nil then Acc
         [] H|T then {TotalDuration T Acc+H.duration}
         [] Z then Z.duration
         end
      end
      DTot={TotalDuration Sample 0.0}
   in
      {Stretch (D/DTot) Sample}
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Fonction Drone

   fun{Drone Note N}
      if N==0 then nil
      else
         {NoteToSample Note 1.0 none}|{Drone Note N-1}
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Fonction Transpose

   fun{Transpose Sample N}
      case Sample
      of nil then nil
      [] H|T then {Transpose H N}|{Transpose T N}
      [] sample(duration:D height:H instrument:I) then sample(duration:D height:H+N instrument:I)
      [] silence(duration:D) then silence(duration:D)
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Fonction qui interprete une partition et retourne une list de "qqch"

   fun {PartitionToTimedList Partition}
      case Partition
      of nil then nil
      [] H|T then {Append {PartitionToTimedList H} {PartitionToTimedList T}}
      [] drone(note:N P) then {Drone N {PartitionToTimedList P}}
      [] stretch(factor:F P) then {Stretch F {PartitionToTimedList P}}
      [] duration(seconds:S P) then {Duration S {PartitionToTimedList P}}
      [] transpose(semitones:S P) then {Transpose S {PartitionToTimedList P}}
      [] silence(duration:D) then [silence(duree:D)]
      [] Note then [{NoteToSample Note 1.0 none}]
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun {Mix P2T Music}
      % TODO
      {Project.readFile 'wave/animaux/cow.wav'}
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   Music = {Project.load 'C:/Users/augus/Documents/EPL/Q3/LFSAB1402-Informatique_2/DimiEtAugu/joy.dj.oz'}
   Start

   % Uncomment next line to insert your tests.
   % \insert 'tests.oz'
   % !!! Remove this before submitting.
in
   Start = {Time}

   % Uncomment next line to run your tests.
   % {Test Mix PartitionToTimedList}

   % Add variables to this list to avoid "local variable used only once"
   % warnings.
   {ForAll [NoteToExtended Music] Wait}

   % Calls your code, prints the result and outputs the result to out.wav.
   % You don't need to modify this.
   {Browse {Project.run Mix PartitionToTimedList Music 'out.wav'}}

   % Shows the total time to run your code.
   {Browse {IntToFloat {Time}-Start} / 1000.0}
end