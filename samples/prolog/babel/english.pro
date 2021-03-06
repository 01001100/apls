%-----------
% English
%

esentence(M, [CapFirst|Rest], []) :-
  var(M),
  capitalize(First, CapFirst),
  esent(M, [First|Rest], []).
esentence(M, S, []) :-
  var(S),
  esent(M, [First|Rest], []),
  capitalize(First, CapFirst),
  S = [CapFirst|Rest].

esent( identity(subj(S),obj(O)) ) -->
  esubject(S), eisverb(_), eobject(O), eperiod.
esent( identity_question(subj(S),obj(O)) ) -->
  epronoun(O,interrogative), eisverb(_), esubject(S), equestionmark.
esent( identity_question(subj(S),obj(O)) ) -->
  eisverb(_), esubject(S), eobject(O), equestionmark.
esent( identity(not,subj(S),obj(O)) ) -->
  esubject(S), eisverb(_), [not], eobject(O), eperiod.
esent( attribute(subj(S),attr(A)) ) -->
  esubject(S), eisverb(_), eadjlist(A), eperiod.
esent( attribute(not,subj(S),attr(A)) ) -->
  esubject(S), eisverb(_), [not], eadjlist(A), eperiod.
esent( attribute_question(subj(S),attr(A)) ) -->
  eisverb(_), esubject(S), eadjlist(A), equestionmark.

esubject(S) --> epronoun(S).
esubject(S) --> enounphrase(S).

eobject(O) --> enounphrase(O).

enounphrase(N) --> eth_adjs_noun(N).
enounphrase(N) -->
  earticle(_,indefinite,FirstLetter),
  eadjs_noun(N),
  { efirst_letter(N, FirstLetter) }.

eth_adjs_noun(noun(N,[TH|MODs])) --> ethadj(TH), eadjs_noun(noun(N,MODs)).

eadjs_noun(noun(N,MODs)) --> eadjlist(MODs), enoun(N).

eisverb(M) --> [X], { dict(edict,M,X,[ps=verb,is]) }.

epronoun(M) --> [X], { dict(edict,M,X,[ps=pronoun]) }.

epronoun(M,interrogative) --> [X],
  { dict(edict,M,X,[ps=pronoun,interrogative]) }.

enoun(M) --> [X], { dict(edict,M,X,[ps=noun]) }.
enoun(M, In, Out) :-
  dict(edict,M,[X|Y],[ps=noun]),
  append([X|Y], Out, In).

eadjlist([A|X]) --> eadj(A), eadjlist(X).
eadjlist([]) --> [].

ethadj(M) --> [X], { dict(edict,M,X,[ps=thadj]) }.

eadj(M) --> [X], { dict(edict,M,X,[ps=adj]) }.

earticle(M,indefinite,FL) -->
  [X], { dict(edict,M,X,[ps=article,indefinite,first_letter=FL]) }.

eperiod --> ['. '].

equestionmark --> ['?'].

efirst_letter(noun(N,[]), Type) :-
  eletter1(N, Type).
efirst_letter(noun(N,[Mod1|_]), Type) :-
  eletter1(Mod1, Type).

eletter1(Word, vowel) :-
  atom_codes(Word, [First|_]),
  member(First, [0'a,0'e,0'i,0'o,0'u,0'A,0'E,0'I,0'O,0'U]).
eletter1(Word, consonant) :-
  atom_codes(Word, [First|_]),
  not member(First, [0'a,0'e,0'i,0'o,0'u,0'A,0'E,0'I,0'O,0'U]).

edict(indef_art, a, [ps=article,indefinite,first_letter=consonant]).
edict(indef_art, an, [ps=article,indefinite,first_letter=vowel]).
edict(black, black, [ps=adj]).
edict(book, book, [ps=noun]).
edict(box, box, [ps=noun]).
edict(dictionary, dictionary, [ps=noun]).
edict(farthat, that, [ps=pronoun]).
edict(is, is, [ps=verb,is]).
edict(it, it, [ps=pronoun]).
edict(red, red, [ps=adj]).
edict(what, what, [ps=pronoun,interrogative]).
edict(pencil, pencil, [ps=noun]).
edict(that, that, [ps=thadj]).
edict(that, that, [ps=pronoun]).
edict(this, this, [ps=thadj]).
edict(this, this, [ps=pronoun]).
edict(university, university, [ps=noun]).

edict(white, white, [ps=adj]).
edict(blue, blue, [ps=adj]).
edict(school, school, [ps=noun]).
edict(university, university, [ps=noun]).
edict(senior, senior, [ps=adj]).
edict(junior, junior, [ps=adj]).
edict(high, high, [ps=adj]).
edict(grade, grade, [ps=adj]).
edict(farthat, that, [ps=adj]).
edict(letter, letter, [ps=noun]).
edict(window, window, [ps=noun]).
edict(big, big, [ps=adj]).
edict(big, large, [ps=adj]).
edict(small, small, [ps=adj]).
edict(desk, desk, [ps=noun]).
edict(chair, chair, [ps=noun]).
edict(old, old, [ps=adj]).
edict(new, new, [ps=adj]).

