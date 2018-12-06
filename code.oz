
% LFSAB1402 - Informatique 2 - Projet en Oz
% Dimitri Doeran - 28901700
% Augustin d'Oultremont - 22391700

local
   % See project statement for API details.
   [Project] = {Link ['Project2018.ozf']}
   Time = {Link ['x-oz://boot/Time']}.1.getReferenceTime
   Flag


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%               DEBUT DE LA PARTIE PARTITIONTOTIMEDLIST                 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% @Pre : /
%
% @Post : Permet de changer une note en une extended note (un record).
%
   fun {NoteToExtended Note}
      case Note
      of Name#Octave then note(name:Name octave:Octave sharp:true duration:1.0 instrument:none)
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
%
% @Pre : /
%
% @Post : Permet d'étirer ou de compresser la duree d'une partition par le facteur 
%         passe en argument.
%
   fun {Stretch F Note}
      case Note
      of nil then nil
      [] H|T then {Stretch F H}|{Stretch F T}
      [] note(duration:D name:Name octave:Octave sharp:Boolean instrument:I)
         then note(duration:D*F name:Name octave:Octave sharp:Boolean instrument:I)
      [] silence(duration:D) then silence(duration:D*F)
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%
% @Pre : /
%
% @Post : Permet de changer la duree d'une partition. Ceci se fait en appelant
%         la fonction stretch pour etirer les notes/accords avec le bon facteur.
%
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
         [] _ then Note.duration
         end
      end
      DTot={TotalDuration Note 0.0}
   in
      {Stretch (D/DTot) Note}
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%
% @Pre : /
%
% @Post : Permet de repeter plusieurs fois la note ou l'accord passe en 
%         argument.
%
   fun{Drone Note N}
      if N==0 then nil
      else
         case {Flatten Note} of [_] then {Flatten Note|{Drone Note N-1}}
         else Note|{Drone Note N-1}
         end
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%
% @Pre : /
%
% @Post : Permet de transposer de N demitons la partition passee en argument.
%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%
% @Pre : /
%
% @Post : Methode "main" de notre partie PartitionToTimedList. Celle-ci permet 
%         de detecter les differentes forme de Partition au moyen de plusieurs 
%         pattern matching. Ensuite, les fonctions adequates sont appelees. Nous 
%         gerons aussi le cas des accords et dans ce cas nous renvoyons un 
%         tableau (cfr. le pattern matching H1|T1). 
%
   fun {PartitionToTimedList Partition}
      case Partition
      of nil then nil
      [] H|T then
         case H
         of H1|T2 then {Flatten ({PartitionToTimedList H1}|{PartitionToTimedList T2})}|{PartitionToTimedList T}
         [] _ then {Append {PartitionToTimedList H} {PartitionToTimedList T}}
         end
      [] drone(note:Note N) then {Drone {PartitionToTimedList Note} N}
      [] stretch(factor:F P) then {Stretch F {PartitionToTimedList P}}
      [] duration(seconds:S P) then {Duration S {PartitionToTimedList P}}
      [] transpose(semitones:S P) then {Transpose S {PartitionToTimedList P}}
      [] silence(duration:D) then [silence(duration:D)] 
      [] note(duration:D name:Name octave:Octave sharp:Boolean instrument:I)
         then [note(duration:D name:Name octave:Octave sharp:Boolean instrument:I)] 
      [] Note then [{NoteToExtended Note}] 
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                       DEBUT DE LA PARTIE MIX                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%
% @Pre : /
%
% @Post : Permet de renvoyer la hauteur de la note passee en argument.
%
   fun{HeightOfNote Note}
      local S in
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
         (Note.octave-4)*12+S
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% @Pre : /
%
% @Post : Permet de convertir une note en un tableau d'intensite (au moyen de 
%         la formule sinusoidale). 
%
   fun{ToSample Note}
      Freq
      H
      Nmax
      fun{List F I Nmax}
         if I>=Nmax+1.0 then nil
         else 0.5*{Sin 2.0*3.14*F*I/44100.0}|{List F I+1.0 Nmax}
         end
      end
      fun{List2 N} 
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
      [] silence(duration:D) then {List2 {FloatToInt D*44100.0}}
      else Note
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% @Pre : /
%
% @Post : Permet de jouer simultanement plusieurs musiques avec des intensites
%         differentes. 
%

   fun {Merge PT FM}
      fun {MusicIntensitiesToSampleIntensities PtoT A}
         case A
         of _|_ then {List.map A fun{$ Element} case Element of F#Mus then F#{Mix PtoT Mus} end end}
         else {List.map A|nil fun{$ Element} case Element of F#Mus then F#{Mix PtoT Mus} end end}
         end
      end
      fun {MultiplyByFactor A}
         {List.map A fun{$ Element} case Element of F#Sams then {List.map Sams fun{$ E} E*F end} end end}
      end
      fun {AddLists L1 L2}
         case L1#L2
         of nil#nil then nil
         [] _#nil then L1
         [] nil#_ then L2
         [] (H1|T1)#(H2|T2) then (H1+H2)|{AddLists T1 T2}
         end
      end
      fun {MergeSum A Acc}
         case A
         of nil then Acc
         [] H|T then {MergeSum T {AddLists H Acc}}
         end
      end
   in
      {MergeSum {MultiplyByFactor {MusicIntensitiesToSampleIntensities PT FM}} nil}
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% @Pre : /
%
% @Post : Inverse le sens de la musique. 
%
   fun {Reverse L}
      {List.reverse L}
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%
% @Pre : /
%
% @Post : Permet de repeter un certain nombre de fois la musique.
%
   fun {Repeat N L}
      if N==0 then nil
      else {Append L {Repeat N-1 L}}
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% @Pre : /
%
% @Post : Permet de jouer la musique le temps demande. Si la duree est plus 
%         courte que la musique alors la musique est tronquee. Si la duree est 
%         plus grande que la musique, celle ci est jouee au moins une fois plus
%         la potentielle troncature. 
%
   fun {Loop D L}
      local LTot ListLength in
         LTot = {FloatToInt D*44100.0}   
         ListLength = {List.length L}     
         {Append {Repeat (LTot div ListLength) L} {Cut 0 (LTot mod ListLength) L}}
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% @Pre : / 
%
% @Post : Permet de borner les intensites de Low a Higth. Les intensites non 
%         comprises dans les bornes sont saturees a la borne la plus proche.
%
   fun {Clip Low High L}
      case L
      of nil then nil
      [] H|T then {Clip Low High H}|{Clip Low High T}
      [] Sample then
         if Sample>High then High
         elseif Sample<Low then Low
         else Sample
         end
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% @Pre : /
%
% @Post : Permet de prendre une seule partie de la musique et de supprimer
%         tout le reste. Ici en argument sont les positions dans le tableau.
%
   fun{Cut Start End L} 
      if Start > 0 then
         case L
         of _|T then {Cut Start-1 End-1 T}
         else {Cut Start-1 End-1 L}
         end
      else
         if End > 0 then
            case L
            of H|T then H|{Cut 0 End-1 T}
            else 0.0|{Cut 0 End-1 L}
            end
         else nil
         end
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% @Pre : /
%
% @Post : Permet d'ajouter un echo a la musique passee en argument
%
   fun {Echo Delay Decay M}
      merge([1.0#M Decay#(silence(duration:Delay)|M)])
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% @Pre : /
%
% @Post : Permet de gerer les accords. Pour ce faire on additionne vectoriellement
%         les notes présentes dans les tableaux. 
%         
%
   fun {Chord L}
      local Factor in
         Factor = 1.0/{IntToFloat {List.length L}}
         merge({List.map L fun{$ Element} Factor#Element end})
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% @Pre : /
%
% @Post : Permet d'attenuer en intensite lineairement le debut et la fin d'une 
%         musique.
%
   fun{Fade Start Finish Music}
      fun{FadeLeft Start Music2 Acc}
      	case Music2
      	of H|T then
      	   if Acc==Start*44100.0 then Music2
      	   else (Acc/(Start*44100.0))*H|{FadeLeft Start T Acc+1.0}
      	   end
         [] nil then nil
         end
      end

      fun{FadeRight Finish Music2 Acc}
   	   local
   	      MusicLength = {IntToFloat {List.length Music2}}
   	      LeftList = {Cut 0 {FloatToInt (MusicLength-(Finish*44100.0)-1.0)} Music2}
   	      RightList = {Cut {FloatToInt (MusicLength-(Finish*44100.0))} {FloatToInt MusicLength} Music2}
   	   in
   	      {Append LeftList {List.reverse {FadeLeft Finish {List.reverse RightList} Acc}}}
   	   end
      end

   in
      {FadeLeft Start {FadeRight Finish Music 0.0} 0.0}
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% @Pre : /
%
% @Post : Methode "main" de notre partie Mix. Celle-ci permet de detecter les differentes 
%         forme de Music au moyen de plusieurs pattern matching. Ensuite, les fonctions 
%         adequates sont appelees. Nous gerons aussi le cas des accords (cfr. le pattern
%         matching H|T). A la fin se trouve aussi notre lissage sur chaque note. 
%
   fun {Mix P2T Music}
      case Music
      of nil then nil

      [] H|T then
         if {List.is H} then {Append {Mix P2T {Chord H}} {Mix P2T T}}
         else {Append {Mix P2T H} {Mix P2T T}}
         end

      [] samples(S) then S
      [] partition(P) then {Mix P2T {P2T P}}
      [] merge(List) then {Merge P2T List}
      [] wave(FileName) then {Project.readFile FileName}
      [] reverse(M) then {Reverse {Mix P2T M}}
      [] repeat(amount:N M) then {Repeat N {Mix P2T M}}
      [] loop(seconds:D M) then {Loop D {Mix P2T M}}
      [] clip(low:L high:H M) then {Clip L H {Mix P2T M}}
      [] echo(delay:Delay decay:Decay M) then {Mix P2T {Echo Delay Decay M}}
      [] cut(start:S finish:F M) then {Cut {FloatToInt S*44100.0} {FloatToInt F*44100.0} {Mix P2T M}}
      [] fade(start:Start out:Out M) then {Fade Start Out {Mix P2T M}}
      [] Z then
         if Flag==true then
            if (Z.duration > 1000.0/44100.0) then {Fade 500.0/44100.0 500.0/44100.0 {ToSample Z}}
            elseif (Z.duration > 500.0/44100.0) then {Fade 250.0/44100.0 250.0/44100.0 {ToSample Z}}
            else nil
            end
         else {ToSample Z}
         end
      end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   Music = {Project.load 'Mario.oz'}
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                              LISSAGE                                  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Veuillez passer le booleen a "true" si vous voulez le lissage        %%%
   Flag = true                                                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   % Calls your code, prints the result and outputs the result to out.wav.
   % You don't need to modify this.
   {Browse {Project.run Mix PartitionToTimedList Music 'out.wav'}}

   % Shows the total time to run your code.
   {Browse {IntToFloat {Time}-Start} / 1000.0}
end