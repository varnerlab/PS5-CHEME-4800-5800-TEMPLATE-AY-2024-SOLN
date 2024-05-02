# include -
include("Include.jl")

edgefile = joinpath(_PATH_TO_DATA, "Bipartite.edgelist"); # Bipartite graph edge file path
# edgefile = joinpath(_PATH_TO_DATA, "Bipartite-MultipleAssignment.edgelist"); # Bipartite graph w/multiple assignments possible
required_value = 3.0; # required value for the flow in this problem (the number of tasks)
graphmodel = readedgesfile(edgefile) |> edges -> build(MySimpleDirectedGraphModel, edges);
solution = solve(graphmodel, required_value);
flowvector = solution["argmin"]; # this is the solution vector

nodes = graphmodel.nodes;
edges = graphmodel.edges;
edgesinverse = graphmodel.edgesinverse;

people_node_set = Set{Int64}();
for (k,v) ∈ edges
    if k[1] == 1
        push!(people_node_set, k[2]);
    end
end

# get the list of edges connected to the people nodes -
total_flow_vector_per_person = Dict{Int64, Float64}();
for person ∈ people_node_set
    total_flow_vector_per_person[person] = 0.0;
    for (k,v) ∈ edgesinverse
        if v[1] == person
             total_flow_vector_per_person[person] += flowvector[k];
        end
    end
end

idx_more_than_one_task = findall(x -> x > 1, total_flow_vector_per_person); # find all people with more than one task
@assert isempty(idx_more_than_one_task) == true;