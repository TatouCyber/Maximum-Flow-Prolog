load_graph(File) :-
    read_terms(File, Terms),
    maplist(is_valid,Terms),
    include(is_edge,Terms,Edges),
    include(is_node2,Terms,Nodes),
    graph_correcte(Edges,Nodes),
    maplist(assertz, Terms).

graph_correcte(/* completer */):-
    /* completer */ .

is_valid(Term):-
    is_edge(Term);
    is_node2(Term);
    is_source(Term);
    is_sink(Term).

is_valid(Term):-
    write("Non valide: "),write(Term),nl,
    fail.

is_edge(edge(X, Y, C)) :-
    atom(X),
    atom(Y),
    number(C),
    C >= 0.

is_node2(Term):-
    is_node1(Term);
    is_sink(Term);
    is_source(Term).

is_node1(node(X)):-
    atom(X).

is_source(source(X)):-
    atom(X).

is_sink(sink(X)):-
    atom(X).

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

