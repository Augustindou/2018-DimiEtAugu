
local
   % See project statement for API details.
   [Project] = {Link ['Project2018.ozf']}
   Time = {Link ['x-oz://boot/Time']}.1.getReferenceTime


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%      DEBUT DE LA PARTIE PARTITIONTOTIMEDLIST
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
      %[] H|T then {NoteToExtended H}|{NoteToExtended T} %%Dimi
      end
   end


   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OK
   %Fonction Stretch

   fun {Stretch F Note}
      case Note
      of nil then nil
      [] H|T then {Stretch F H}|{Stretch F T}
      [] note(duration:D name:Name octave:Octave sharp:Boolean instrument:I)
         then note(duration:D*F name:Name octave:Octave sharp:Boolean instrument:I)
      [] silence(duration:D) then silence(duration:D*F)
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OK
   %Fonction Duration

   fun {Duration D Note}
      fun{TotalDuration Note Acc}
         case Note
         of nil then Acc
         [] H|T then
            if {List.is H} then
               {TotalDuration T Acc+H.1.duration}
            else
               {TotalDuration T Acc+H.duration}
            end
         %{TotalDuration T Acc+H.duration} %% Dimi
         [] Z then Z.duration
         end
      end
      DTot={TotalDuration Note 0.0}
   in
      {Stretch (D/DTot) Note}
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OK
   %Fonction Drone

   fun{Drone Note N}
      %{Browse Note}
      if N==0 then nil
      else
	      case {Flatten Note} of [_] then {Flatten Note|{Drone Note N-1}}
	      else Note|{Drone Note N-1}
	      end
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OK
   %Fonction Transpose

   fun{Transpose N Note}

      case Note
      of nil then nil
      [] H|T then {Transpose N H}|{Transpose N T}
      [] silence(duration:D) then silence(duration:D)
      [] note(name:Name octave:Octave sharp:Sharp duration:D instrument:I) then
         local R S in
            case Name#Sharp
            of a#false then R = Octave*12
            [] a#true then R = Octave*12 + 1
            [] b#false then R = Octave*12 + 2
            [] c#false then R = Octave*12 - 9
            [] c#true then R = Octave*12 - 8
            [] d#false then R = Octave*12 - 7
            [] d#true then R = Octave*12 - 6
            [] e#false then R = Octave*12 - 5
            [] f#false then R = Octave*12 - 4
            [] f#true then R = Octave*12 - 3
            [] g#false then R = Octave*12 - 2
            [] g#true then R = Octave*12 - 1
            end
            S = R + N
            case (S mod 12)
            of 0 then note(name:a octave:(S div 12) sharp:false duration:D instrument:I)
            [] 1 then note(name:a octave:(S div 12) sharp:true duration:D instrument:I)
            [] 2 then note(name:b octave:(S div 12) sharp:false duration:D instrument:I)
            [] 3 then note(name:c octave:(S div 12)+1 sharp:false duration:D instrument:I)
            [] 4 then note(name:c octave:(S div 12)+1 sharp:true duration:D instrument:I)
            [] 5 then note(name:d octave:(S div 12)+1 sharp:false duration:D instrument:I)
            [] 6 then note(name:d octave:(S div 12)+1 sharp:true duration:D instrument:I)
            [] 7 then note(name:e octave:(S div 12)+1 sharp:false duration:D instrument:I)
            [] 8 then note(name:f octave:(S div 12)+1 sharp:false duration:D instrument:I)
            [] 9 then note(name:f octave:(S div 12)+1 sharp:true duration:D instrument:I)
            [] 10 then note(name:g octave:(S div 12)+1 sharp:false duration:D instrument:I)
            [] 11 then note(name:g octave:(S div 12)+1 sharp:true duration:D instrument:I)
            end
         end
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% OKOKOKOK
   %Fonction qui interprete une partition et retourne une list de "qqch"

   fun {PartitionToTimedList Partition}
      case Partition
      of nil then nil
      [] H|T then
         case H
         of H1|T2 then {Flatten ({PartitionToTimedList H1}|{PartitionToTimedList T2})}|{PartitionToTimedList T}
                       %Flatten pour le problemes des accords (la premiere note etait une liste )
         [] Z then {Append {PartitionToTimedList H} {PartitionToTimedList T}}
         end
      [] drone(note:Note N) then {Drone {PartitionToTimedList Note} N}
      [] stretch(factor:F P) then {Stretch F {PartitionToTimedList P}}
      [] duration(seconds:S P) then {Duration S {PartitionToTimedList P}}
      [] transpose(semitones:S P) then {Transpose S {PartitionToTimedList P}}
      [] silence(duration:D) then [silence(duration:D)] %%Dimi
      [] note(duration:D name:Name octave:Octave sharp:Boolean instrument:I)
         then [note(duration:D name:Name octave:Octave sharp:Boolean instrument:I)] %%DIMI
      [] Note then [{NoteToExtended Note}] %%Dimi %%Warning
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%      DEBUT DE LA PARTIE MIX
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun{HeightOfNote Note}
      local H S in
         case Note.name#Note.sharp
         of a#false then S=0
         [] a#true then S=1
         [] b#false then S=2
         [] c#false then S=~9
         [] c#true then S=~8
         [] d#false then S=~7
         [] d#true then S=~6
         [] e#false then S=~5
         [] f#false then S=~4
         [] f#true then S=~3
         [] g#false then S=~2
         [] g#true then S=~1
         end
      H = (Note.octave-4)*12+S      % on peut juste mettre (Note.octave-4)*12+S aussi
      H                             % au lieu de définir H et de le renvoyer
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun{ToVector Note}
      Freq
      H
      Nmax
      fun{List F I Nmax}
         if I>=Nmax+1.0 then nil
         else
            0.5*{Sin 2.0*3.14*F*I/44100.0}|{List F I+1.0 Nmax}
         end
      end
      fun{List2 N}%cas du silence
         if N==0 then nil
         else 0.0|{List2 N-1}
         end
      end
   in
      case Note
      of note(name:Name octave:Octave sharp:Boolean duration:D instrument:I) then
         H={IntToFloat {HeightOfNote Note}}
         Freq={Pow 2.0 H/12.0}*440.0
         Nmax=Note.duration*44100.0
         {List Freq 1.0 Nmax}
      [] silence(duree:D) then {List2 {FloatToInt D*44100.0}}
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Dans le cas où c'est un
   fun{ToListOfVector L}
      case L of nil then nil
      [] H|T then {Append {ToVector H} {ToListOfVector T}}
      [] A then {ToVector A}
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Reverse ;) ça devrait marcher non?

   fun {Reverse L}
      {List.reverse L}
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Repeat ;)

   fun {Repeat N L}
      if N==0 then nil
      else L|{Repeat N-1 L}
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   fun {Mix P2T Music}
      case Music
      of nil then nil
      [] H|T then {Append {Mix PartitionToTimedList H} {Mix PartitionToTimedList T}}
      [] partition(P) then  {Mix PartitionToTimedList {PartitionToTimedList P}}

      % En gros je vais reverse un tableau de note, extended note et tt ce que tu vx
      %(d'où le {Mix PartitionToTimedList M} dans reverse, pour obtenir une timed list)
      [] reverse(M) then {Mix PartitionToTimedList {Reverse {Mix PartitionToTimedList M}}}

      % Même remarque pour {Mix PartitionToTimedList M} dans repeat
      [] repeat(amount:N M) then {Mix PartitionToTimedList {Repeat N {Mix PartitionToTimedList M}}}

      [] Z then {ToListOfVector Z}
      end
   end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   Music = {Project.load 'joy.dj.oz'}
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


% PROBLEMES !
%
%1) Le stretch, bourdon renvoit des tableaux, donc des accords... Pas dingue                     V DONE
%
%2) Le transpose se chie dessus                                                                  V DONE
%
%3) Regler duration avec les tableaux                                                            V DONE
%
%
%
%
%
%
%
%
%
