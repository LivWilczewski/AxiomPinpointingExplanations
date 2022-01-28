% Facts about sequences

% pain sequence example
event(s1, e1, 1.3, 4.91, au10, 2).
event(s1, e2, 1.5, 4.4, au07, 3).
event(s1, e3, 2.5, 4.4, au04, 4).
event(s1, e4, 2.7, 4.4, au09, 5).
event(s1, e5, 2.9, 3.86, au25, 3).
event(s1, e6, 3.1, 4.4, au06, 4).
event(s1, e7, 3.8, 3.8, au25, 3).
event(s1, e8, 4.5, 4.8, au09, 3).
event(s1, e9, 4.6, 4.9, au07, 2).

% disgust sequence example
event(s2, e10, 0.6, 2.4, au04, 3).
event(s2, e11, 2.5, 4.5, au07, 1).
event(s2, e12, 2.7, 5.3, au09, 2).
event(s2, e13, 3.3, 5.3, au15, 2).
event(s2, e14, 3.3, 5.3, au12, 2).

% Allen calculus

is_au(Event, AU) :-
	event(Sequence, Event, Start, End, AU, Intensity).
	
before(Sequence, Event1, Event2) :-
	event(Sequence, Event1, Start1, End1, AU1, Intensity1),
	event(Sequence, Event2, Start2, End2, AU2, Intensity2),
	End1 < Start2.
	
meets(Sequence, Event1, Event2) :-
	event(Sequence, Event1, Start1, End1, AU1, Intensity1),
	event(Sequence, Event2, Start2, End2, AU2, Intensity2),
	End1 == Start2.
	
overlaps(Sequence, Event1, Event2) :-
	event(Sequence, Event1, Start1, End1, AU1, Intensity1),
	event(Sequence, Event2, Start2, End2, AU2, Intensity2),
	Start1 < Start2,
	End1 > Start2,
	End1 < End2.
	
starts_with(Sequence, Event1, Event2) :-
	event(Sequence, Event1, Start1, End1, AU1, Intensity1),
	event(Sequence, Event2, Start2, End2, AU2, Intensity2),
	Start1 == Start2,
	End1 < End2.
	
during(Sequence, Event1, Event2) :-
	event(Sequence, Event1, Start1, End1, AU1, Intensity1),
	event(Sequence, Event2, Start2, End2, AU2, Intensity2),
	Start1 > Start2,
	End1 < End2.
	
finishes_with(Sequence, Event1, Event2) :-
	event(Sequence, Event1, Start1, End1, AU1, Intensity1),
	event(Sequence, Event2, Start2, End2, AU2, Intensity2),
	Start1 > Start2,
	End1 == End2.
	
equal_duration(Sequence, Event1, Event2) :-
	event(Sequence, Event1, Start1, End1, AU1, Intensity1),
	event(Sequence, Event2, Start2, End2, AU2, Intensity2),
	Event1 \= Event2,
	Start1 == Start2,
	End1 == End2.

% equalIntensity(S, E1, E2) :- 
%	event(S, E1, _, _, _, I), event(S, E2, _, _, _, I), E1 \= E2.

% equalDurationAndIntensity(S, E1, E2) :- 
%	equal_duration(S, E1, E2), equalIntensity(S, E1, E2).

% Theories

% only AUs considered
% PainAU7AndAU10OfEqualDurationAndSameIntensity
pain(A) :- event(A,B,C,D,au07,E), event(A,F,C,D,au10,E).
% PainAU9FinishesWithAU6OrViceVersaOrAU9EqualDurationAU6
pain(A) :- event(A,B,C,D,au09,E), event(A,F,G,D,au06,H).
% PainAU4AndAU6
pain(A) :- event(A,B,C,D,au04,E), event(A,F,G,H,au06,I).

% Relations between AUs
% PainAU7OverlapsAU6
pain(A) :- overlaps(A,B,C), is_au(C,au06), is_au(B,au07).
% PainAU6FinishesWithAU4
pain(A) :- finishes_with(A,B,C), is_au(B,au06), is_au(C,au04).
% PainBeforeAU7IsAU18
pain(A) :- before(A,B,C), is_au(C,au18), is_au(B,au07).
