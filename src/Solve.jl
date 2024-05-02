"""
    solve(graph::MySimpleDirectedGraphModel, req::Float64) -> Dict{String,Any}

Takes a graph model and a required amount of flow, and returns a dictionary with the minimum cost flow solution.

### Arguments
- `graph::MySimpleDirectedGraphModel`: A graph model of type `MySimpleDirectedGraphModel`. 
- `req::Float64`: A required amount of flow through the graph.

### Returns
- `Dict{String,Any}`: A dictionary with the following keys:
    - `argmin::Array{Float64,1}`: The optimal flow values.
    - `objective_value::Float64`: The optimal objective value.
    - `A::Array{Float64,2}`: The constraint matrix.
    - `b::Array{Float64,1}`: The right hand side of the constraint matrix.
"""
function solve(graph::MySimpleDirectedGraphModel, req::Float64)::Dict{String,Any}

    # initialize -
    results = Dict{String,Any}()
    nodes = graph.nodes;
    edges = graph.edges;
    edgesinverse = graph.edgesinverse;

    # how many edges do we have?
    d = length(edges);
    n = length(nodes);

    # build bounds array -
    bounds = Array{Float64,2}(undef, d, 2);
    edgecounter = 1;
    for source ∈ 1:n
        for target ∈ 1:n
            if haskey(edges, (source, target)) == true
                bounds[edgecounter, 1] = edges[(source, target)][2];
                bounds[edgecounter, 2] = edges[(source, target)][3];
                edgecounter += 1;
            end
        end
    end

    # setup cost vector -
    c = Array{Float64,1}(undef, d);
    costcounter = 1;
    for source ∈ 1:d
        for target ∈ 1:d
            if haskey(edges, (source, target)) == true
                c[costcounter] = edges[(source, target)][1];
                costcounter += 1;
            end
        end
    end

    # build system contraint matrix -
    A = zeros(n, d);
    for (k,v) ∈ edgesinverse
        A[v[1], k] = -1.0;
        A[v[2], k] = 1.0;
    end

    # build the right hand side -
    b = zeros(n);
    b[1] = -1*req;
    b[end] = req;

    # Setup the problem -
    model = Model(GLPK.Optimizer)
    @variable(model, bounds[i,1] <= x[i=1:d] <= bounds[i,2], start=0.0) # we have d variables, setup the bounds 
    @objective(model, Min, transpose(c)*x); # set objective function, min the sum of the costs
    @constraints(model, 
        begin
            # my budget constraint
            A*x == b
        end
    );

    # run the optimization -
    optimize!(model)

    # check: was the optimization successful?
    @assert is_solved_and_feasible(model)

    # populate -
    x_opt = value.(x);
    results["argmin"] = x_opt
    results["objective_value"] = objective_value(model);
    results["A"] = A;
    results["b"] = b;

    # return -
    return results;
end