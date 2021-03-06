behavior(P, passive_aggressive) :-
   childhood(P, powerless) ;
   childhood(P, divorced_parents).
behavior(P, addictive) :-
   childhood(P, love_less).
behavior(P, people_pleaser) :-
   childhood(P, conditional_love).

symptom(P, fails_responsibilies) :-
   behavior(P, passive_aggressive).
symptom(P, sullen) :-
   behavior(P, passive_aggressive).
symptom(P, drinks) :-
   behavior(P, addictive).

person( michael, [ childhood:powerless ] ).
person( dennis, [ childhood:conditional_love ] ).
person( fran, [ childhood:love_less ] ).
person( foo, [ childhood:divorced_parents ] ).

main :-
   retractall(childhood(_,_)),
   write(`Who shall we analyze? `),
   read(P),
   person(P, ATTRS),
   assert_attrs(P, ATTRS),
   behavior(P, B),
   write(P), write(` is most likely `), write(B), nl,
   write(`These are the symptoms we might observe: `), nl,
   symptom(P, S),
   tab(2), write(S), nl,
   fail.
main.

assert_attrs(_, []).
assert_attrs(P, [A:V | AVs]) :-
   FACT =.. [A,P,V],
   assert(FACT),
   assert_attrs(P, AVs).