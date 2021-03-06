%--------------------------------------
% logic.pro - logic interpreter
%
% This is a minor variation on the program found in
% Appendix B of Clocksin & Mellish.  That program
% translates Predicate Calculus formulas into equivalent
% Prolog text. The minor variation is that this version
% takes advantage of Unicode support to use the actual
% Predicate Calculus operators, rather than ASCII
% substitutions.
%
% Set the font to Lucida Sans Unicode to see the operators
% in both the source code listing and when you run the
% program in the interpreter.
%
% The Character Map program with Windows NT is a convenient
% way to get Unicode characters.  For this program, you can
% simply cut and paste the operators in as needed.
%
% An interesting Logic Server project might be to build a
% front-end on this program that lets the user click on the
% operators to build the formulas.
%

:- op(200, fx, ¬).
:- op(400, xfy, ∨).
:- op(400, xfy, ∧).
:- op(700, xfy, ⊃).
:- op(700, xfy, ≡).
:- op(900, fy, ∀).
:- op(900, fy, ∃).
:- op(800, xfx, ∙).
:- op(950, xfy, ⇨).
:- op(950, fx, ⇨).

main :-
  test.

% Some sample formulas to translate

f( ∀X∙breaths(X) ≡ alive(X) ).
f( ∀X∙man(X) ⊃ ( ∀Y∙woman(Y) ⊃ likes(X,Y) ) ).
f( ∀X∙animal(X) ⊃ (∃Y∙motherof(X,Y)) ).
f( human(X)  ⊃ ¬(∀X∙mortal(X)) ).

test :-
  f(X),
  translate(X),
  fail.
test.

% See Clocksin & Mellish for details on how the program works.
% Chapter 10 describes the relationship between logic and Prolog,
% and Appendix B contains the actual program description.

translate(X) :-
  implout(X, X1), X ⇨ X1,
  negin(X1, X2), ⇨ X2,
  skolem(X2, X3, []), ⇨ X3,
  univout(X3, X4), ⇨ X4,
  conjn(X4, X5), ⇨ X5,
  clausify(X5, Clauses, []), ⇨ Clauses, nl,
  pclauses(Clauses).

% The arrow operator is just for diagnostic display and because
% I wanted to use at least one of the large number of arrows
% available in Unicode.

X ⇨ Y :-
  nl, nl, write(X), nl,
  tab(2), write('⇨'), nl,
  write(Y), nl.

⇨ X :-
  tab(2), write('⇨'), nl,
  write(X), nl.

implout( P ≡ Q, (P1 ∧ Q1) ∨(¬P1 ∧ ¬Q1) ) :-
  !,
  implout(P, P1),
  implout(Q, Q1).
implout( P ⊃ Q,  ¬P1 ∨ Q1 ) :-
  !,
  implout(P, P1),
  implout(Q, Q1).
implout( ∀X∙P, ∀X∙P1 ) :-
  !,
  implout(P, P1).
implout( ∃X∙P, ∃X∙P1 ) :-
  !,
  implout(P, P1).
implout( P ∧ Q, P1 ∧ Q1 ) :-
  !,
  implout(P, P1),
  implout(Q, Q1).
implout( P ∨ Q, P1 ∨ Q1 ) :-
  !,
  implout(P, P1),
  implout(Q, Q1).
implout(  ¬P,  ¬P1 ) :-
  !,
  implout(P, P1).
implout(P, P).

negin( ¬P, P1) :-
  !,
  neg(P, P1).
negin( ∀X∙P, ∀X∙P1 ) :-
  !,
  negin(P, P1).
negin( ∃X∙P, ∃X∙P1 ) :-
  !,
  negin(P, P1).
negin( P ∧ Q, P1 ∧ Q1 ) :-
  !,
  negin(P, P1),
  negin(Q, Q1).
negin(  P ∨ Q, P1 ∨ Q1 ) :-
  !,
  negin(P, P1),
  negin(Q, Q1).
negin(P,P).

neg(¬P, P1) :-
  !,
  negin(P, P1).
neg( ∀X∙P, ∃X∙P1 ) :-
  !,
  neg(P, P1).
neg( ∃X∙P,  ∀X∙P1 ) :-
  !,
  neg(P, P1).
neg( P ∧ Q, P1∨ Q1 ) :-
  !,
  neg(P, P1),
  neg(Q, Q1).
neg( P ∨ Q, P1 ∧ Q1 ) :-
  !,
  neg(P, P1),
  neg(Q, Q1).
neg( P, ¬P ).

skolem( ∀X∙P, ∀X∙P1, Vars) :-
  !,
  skolem(P, P1, [X|Vars]).
skolem( ∃X∙P, P2, Vars) :-
  !,
  gensym(f, F),
  Sk =.. [F|Vars],
  subst(X, Sk, P, P1),
  skolem(P1, P2, Vars).
skolem( P ∨ Q, P1 ∨ Q1, Vars) :-
  !,
  skolem(P, P1, Vars),
  skolem(Q, Q1, Vars).
skolem( P ∧ Q, P1 ∧ Q1, Vars) :-
  !,
  skolem(P, P1, Vars),
  skolem(Q, Q1, Vars).
skolem(P, P, _).

subst(X, X, P, P).

univout(∀X∙P, P1) :-
  !,
  univout(P, P1).
univout( P ∧ Q, P1 ∧ Q1 ) :-
  !,
  univout(P, P1),
  univout(Q, Q1).
univout( P ∨ Q, P1 ∨ Q1 ) :-
  !,
  univout(P, P1),
  univout(Q, Q1).
univout(P, P).

conjn( P ∨ Q, R) :-
  !,
  conjn(P, P1),
  conjn(Q, Q1),
  conjn1( P1 ∨ Q1, R).
conjn( P ∧ Q, P1 ∧ Q1 ) :-
  !,
  conjn(P, P1),
  conjn(Q, Q1).
conjn(X,X).

conjn1( (P ∧ Q) ∨ R, P1 ∧ Q1) :-
  !,
  conjn( P ∨ R, P1),
  conjn( Q ∨ R, Q1).
conjn1( P ∨ (Q ∧ R), P1 ∧ Q1) :-
  !,
  conjn( P ∨ Q, P1),
  conjn( P ∨ R, Q1).
conjn1(X, X).

clausify( P ∧ Q, C1, C2) :-
  !,
  clausify(P, C1, C3),
  clausify(Q, C3, C2).
clausify(P, [cl(A,B) | Cs], Cs) :-
  inclause(P, A, [], B, []),
  !.
clausify(_, C, C).

inclause( P ∨ Q, A, A1, B, B1) :-
  !,
  inclause(P, A2, A1, B2, B1),
  inclause(Q, A, A2, B, B2).
inclause( ¬P, A, A, B1, B) :-
  !,
  notin(P, A),
  putin(P, B, B1).
inclause(P, A1, A, B, B) :-
  notin(P, B),
  putin(P, A, A1).

notin(X, [X|_]) :- !, fail.
notin(X, [_|L]) :- !, notin(X, L).
notin(X, []).

putin(X, [], [X]) :- !.
putin(X, [X|L], [X|L]) :- !.
putin(X, [Y|L], [Y|L1]) :- putin(X, L, L1).

pclauses([]) :- !, nl, nl.
pclauses([cl(A,B)|Cs]) :-
  pclause(A, B), nl,
  pclauses(Cs).

pclause(L, []) :-
  !,
  pdisj(L),
  write('.').
pclause([],L) :-
  !,
  write(':- '),
  pconj(L),
  write('.').
pclause(L1, L2) :-
  pdisj(L1),
  write(' :- '),
  pconj(L2),
  write('.').

pdisj([L]) :- !, write(L).
pdisj([L|Ls]) :- write(L), write('; '), pdisj(Ls).

pconj([L]) :- !, write(L).
pconj([L|Ls]) :- write(L), write(', '), pconj(Ls).



