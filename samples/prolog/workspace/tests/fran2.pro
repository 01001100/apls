condition( passive_aggressive,
  [ roots - [ childhood = powerless ],
    symptoms - [ behavior = fail_responsibilities, behavior = sullen ],
    citation - `en.wikipedia.org/wiki/Passive-aggressive_behavior` ] ).

condition( alcoholic,
  [ roots - [ childhood = love_less ],
    symptoms - [ behavior = compulsive_drinking ],
    citation - `me` ] ).

condition( people_pleaser,
  [ roots - [ childhood = conditional_love ],
    symptoms - [ behavior = serving_others ],
    citation - `me` ] ).
   
describe( X ) :-
  condition(X, AVs),
  write_avs(AVs).
  
write_avs( [] ) :- nl.
write_avs( [A - Vs | AVs ] ) :-
   write(A), nl,
   tab(2), write(Vs),
   nl, nl,
   write_avs(AVs).

find_condition(C) :-
   condition(C, AVs),
   member(roots - ROOTS, AVs),

assert_attrs(_, []).
assert_attrs(P, [A:V | AVs]) :-
   FACT =.. [A,P,V],
   assert(FACT),
   assert_attrs(P, AVs).