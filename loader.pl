load_graph(File) :-
    read_terms(File, Terms),
    maplist(assertz, Terms).

read_terms(File, Terms) :-
    open(File, read, Stream),
    read_all_terms(Stream, Terms),
    close(Stream).

read_all_terms(Stream, []) :-
    at_end_of_stream(Stream).

read_all_terms(Stream, [Term|Rest]) :-
    \+ at_end_of_stream(Stream),
    read(Stream, Term),
    read_all_terms(Stream, Rest).

