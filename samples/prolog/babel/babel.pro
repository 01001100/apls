%----------------------------------------------------
% BABEL.PRO - Multilanguage translation
%
% An Amzi! inc. demonstration program. (www.amzi.com)
% This program can be freely used and modified, although
% acknowledgment is appreciated.
%
%
% Babel illustrates some basic ideas of machine
% translation.  It takes an input sentence in any
% of the supported languages, and then outputs what
% it believes the 'meaning' of the sentence is.  It
% then uses that meaning to generate translations in
% the other supported languages.  (Not all languages
% will support all meanings.)
%
% It uses Prolog's Definite Clause Grammar (DCG) rules
% to define the relationship between sentences and
% meanings.  Sentences are represented as lists of
% words and punctuation marks.  ex. ['This', is, a,
% book, '. '].  Meanings are represented by Prolog
% structures.  ex. identity(this,book).
%
% Because Prolog rules, including DCG rules, can be
% used in multiple ways, the same grammar rules can
% be used to both translate a sentence into a meaning,
% and a meaning into a sentence.  This is the essence
% of Babel.
%
% Babel reads a sentence and then inputs it to each
% language's rule for 'sentence'.  When it finds one
% that succesfully generates a 'meaning', it then
% takes that 'meaning' and inputs it to each language's
% 'sentence' rules again, this time generating
% sentences.  There might be multiple meanings to
% a sentence, and multiple sentences for a meaning.
%
% To use it, consult the project and enter main at the
% ?- prompt.  Enter a sentence.  When you are done simply
% enter.  Look at the grammar rules and vocabulary
% to see what types of sentences will work, as Babel
% has a very limited vocabulary and knowledge of sentence
% types.
%
% Some examples: This is a book.  This is a red book.
% That is a black box.  Is this a big black book?
%
% There are separate files for a number of languages,
% each with some limited knowledge of sentences and
% words.  If you expand any of these examples, please
% let us know. japanese.pro is saved as a wide-character
% (Unicode) file, and requires a font, such as msmincho,
% to see it.
%
% Note - This program was inspired by the addition of
% Unicode support in Amzi! Prolog and one semester of
% beginning Japanese taken by the author.  The sample
% sentences are based on 'Colloquial Japanese' by
% Noboru Inamoto.

:- import(list).

main :-
  go.

languages([japanese, english, latin, german, spanish]).

go :-
  repeat,
  nl, write($Sentence: $),
  read_string(S),
  tran(S),
  S = $$.

tran(S) :-
  string_tokens(S, Tokens),
  get_meaning(Tokens, Meaning, Lang1),
  nl, write(Lang1), write($: $),
  write(Meaning), nl, nl,
  get_translations(Lang1, Meaning, Lang2, Sentence),
  write(Lang2), write($: $),
  write_sentence(Lang2, Sentence), nl,
  fail.
tran(_).

get_translations(Lang1, Meaning, Lang2, Sentence) :-
  languages(Langs),
  remove(Lang1, Langs, TranLangs),
  member(Lang2, TranLangs),
  sentence(Lang2, Meaning, Sentence).

get_meaning(Tokens, Meaning, Language) :-
  languages(Langs),
  member(Language, Langs),
  sentence(Language, Meaning, Tokens).

sentence(japanese, M, Ts) :-
  jsentence(M, Ts, []).
sentence(english, M, Ts) :-
  esentence(M, Ts, []).
sentence(latin, M, Ts) :-
  lsentence(M, Ts, []).
sentence(german, M, Ts) :-
  gsentence(M, Ts, []).
sentence(spanish, M, Ts) :-
  ssentence(M, Ts, []).

write_sentence(spanish, S) :-
  !,
  swrite_sentence(S).
write_sentence(_, S) :-
  write_sentence(S).


%---------------
% Utilities
%

isupper(L) :-
  L >= 0'A,
  L =< 0'Z.

islower(L) :-
  L >= 0'a,
  L =< 0'z.

uplow(U,L) :-
  var(U), integer(L), !,
  U is L + (0'A - 0'a).
uplow(U,L) :-
  var(L), integer(U), !,
  L is U - (0'A - 0'a).
uplow(U,L) :-
  integer(L), integer(U),
  U is L + (0'A - 0'a).

iscapitalized(Word) :-
  atom(Word),
  atom_codes(Word, [First|Rest]),
  isupper(First).

capitalize(Word, CapWord) :-
  var(CapWord), atom(Word), !,
  atom_codes(Word, [First|Rest]),
  uplow(CapFirst, First),
  atom_codes(CapWord, [CapFirst|Rest]).
capitalize(Word, CapWord) :-
  var(Word), atom(CapWord), !,
  atom_codes(CapWord, [CapFirst|Rest]),
  uplow(CapFirst, First),
  atom_codes(Word, [First|Rest]).
capitalize(Word, CapWord) :-
  atom(Word), atom(CapWord),
  atom_codes(Word, [First|Rest]),
  atom_codes(CapWord, [CapFirst|Rest]),
  uplow(CapFirst, First).

dict(D, M, X, Parms) :-
  Q =.. [D, M, X, Attrs],
  call(Q),
  satisfy(Parms, Attrs).

% 5 argument form for dictionaries with roman
% and native character spellings
dict(D, M, X, Y, Parms) :-
  Q =.. [D, M, X, Y, Attrs],
  call(Q),
  satisfy(Parms, Attrs).

satisfy([], _).
satisfy([AV|Z], Attrs) :-
  member(AV, Attrs),
  satisfy(Z, Attrs).

write_sentence([First|Rest]) :-
  write(First),
  write_sent(Rest).

write_sent([]).
write_sent(['. ']) :-
  write('. '), !.
write_sent(['?']) :-
  write('?'), !.
write_sent([X|Y]) :-
  write($ $), write(X),
  write_sent(Y).

first_letter(Word, LetterList) :-
  atom_codes(Word, [First|_]),
  member(First, LetterList).

