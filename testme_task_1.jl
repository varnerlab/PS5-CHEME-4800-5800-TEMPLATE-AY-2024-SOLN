# include -
include("Include.jl")

# ----------------------------------------------------------------------------------
# for more information on tests, see: https://docs.julialang.org/en/v1/stdlib/Test/
# ----------------------------------------------------------------------------------

# Testset - we *should* write a unit test for each *public* function in our code!
@testset verbose = true "Problem Set 5 Test Set" begin

    # Prerequisites -
    edgefile = joinpath(_PATH_TO_DATA, "Bipartite.edgelist"); # Bipartite graph edge file path
    required_value = 3.0; # required value for the flow in this problem (the number of tasks)

    # Let's test the readedgesfile function, and build function for the graph model -
    graphmodel = readedgesfile(edgefile) |> edges -> build(MySimpleDirectedGraphModel, edges); # build a dictionary of edges, pass to build function
    nodes = graphmodel.nodes;
    edges = graphmodel.edges;
    edgesinverse = graphmodel.edgesinverse;
    @test typeof(nodes) == Dict{Int64, MyGraphNodeModel};
    @test typeof(edges) == Dict{Tuple{Int64, Int64}, Tuple{Float64, Float64, Float64}};
    @test typeof(edgesinverse) == Dict{Int, Tuple{Int, Int}};
    @test length(nodes) == 8;
    @test length(edges) == 15;
    @test length(edgesinverse) == 15;
    
    # Let's test the solve function -
    solution = solve(graphmodel, required_value);
    @test typeof(solution) == Dict{String, Any};
    @test haskey(solution, "argmin") == true;
    @test haskey(solution, "objective_value") == true;

    # test values for the actual solution -
    @test solution["objective_value"] == 3.0;

    # ok, so we need to test to see if each person is connected to a single task, get the flow vector -
    flowvector = solution["argmin"];

    # which nodes are connected to node 1 (these will be people nodes) -
    people_node_set = Set{Int64}();
    for (k,v) ∈ edges
        if k[1] == 1
            push!(people_node_set, k[2]);
        end
    end

    # ok, compute the number of connections that any person has. 
    # store in the total_flow_vector_per_person dictionary. 
    total_flow_vector_per_person = Dict{Int64, Float64}();
    for person ∈ people_node_set
        total_flow_vector_per_person[person] = 0.0;
        for (k,v) ∈ edgesinverse
            if v[1] == person
                total_flow_vector_per_person[person] += flowvector[k];
            end
        end
    end

    # ok, so does any person have more than one task?
    idx_more_than_one_task = findall(x -> x > 1, total_flow_vector_per_person); # find all people with more than one task
    @test isempty(idx_more_than_one_task) == true;
end