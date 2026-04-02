:- consult('loader.pl').
:- consult('fordFulkerson.pl').
:- consult('solution.pl').

solve(File) :-
    load_graph(File),
    graph_data(Edges, _Nodes, Source, Sink),
    auxiliary_graph(Edges, Edges, Residual0),
    fordfurkeson(Residual0, Source, Sink, ResidualF),
    solution_table(Edges, ResidualF, Table),
    flow_value(Source, Table, Value),
    print_solution(Value, Table).

run :-
    solve('graph.pl').