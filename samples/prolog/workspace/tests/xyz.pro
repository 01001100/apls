/*
:- op(250,xfx,:).
initial(1).
final(1).
arc(1,1,'we can use this program to transduce text into drawing':'우리는 이 프로그램을 텍스트를 그림으로 변환하기 위해 사용할 수 있습니다').
arc(1,1,'In implementing finite state transducers in Prolog, we will follow the same strategy that we used for another FST': '프롤로그에서 유한 상태 변환기를 구현하는데 있어서, 우리는 또 다른 FST에 대해 사용한 동일 전략을 따를 수 있다').
transduce1(Node,[],[]):- final(Node).
transduce1(Node1,Tape1,Tape2):- arc(Node1,Node2,Label),traverse1(Label,Tape1,NewTape1,Tape2,NewTape2), transduce1(Node2,NewTape1,NewTape2).
traverse1(L1:L2,[L1|RestTape1],RestTape1,[L2|RestTape2],RestTape2).
testtrans1(Tape1,Tape2):- initial(Node),transduce1(Node,Tape1,Tape2).
*/

np(nogap) --> det,n.
np(nogap) --> det,n,rel.
np(nogap) --> pn.
np(nogap) --> pn,rel.
np(gap(np)) --> [].

s(Gap) --> np(nogap),vp(Gap).
vp(Gap) --> v(1),np(Gap).
rel --> prorel,s(gap(np)).
rel--> prorel,vp(nogap).
n--> [housewife].
n--> [pitcher].
pn--> [harry].
det--> [a].
det--> [the].
v(1)--> [likes].
prorel --> [who].
prorel--> [which].

replace_string(In, Vars, Out) :-
   fill_in_string(In, Vars, StringList),
   stringlist_concat(StringList, ``, Out).
fill_in_string([], _, []).
fill_in_string([I|In], Vars, [I|Out]) :-
   string(I),
   fill_in_string(In, Vars, Out).
fill_in_string([I | In], [V | Vars], [I | Out]) :-
   var(I),
   string_term(X, V),
   I = X,
   fill_in_string(In, Vars, Out).

realize(IN, PRECISION, OUT) :-
   OUT is round( IN * 10 ** PRECISION ) / 10 ** PRECISION.
   
   
