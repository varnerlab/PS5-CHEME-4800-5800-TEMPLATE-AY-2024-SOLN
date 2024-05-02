# ---- PRIVATE METHODS BELOW HERE ------------------------------------------------------------------------------------- #
function _build(edgemodel::Type{MyGraphEdgeModel}, parts::Array{String,1}, id::Int64)::MyGraphEdgeModel
    
    # initialize -
    model = edgemodel(); # build an empty edge model
    
    # populate -
    model.id = id;
    model.source = parse(Int64, parts[1]);
    model.target = parse(Int64, parts[2]);
    model.cost = parse(Float64, parts[3]);
    model.lower_bound_capacity = parse(Float64, parts[4]);
    model.upper_bound_capacity = parse(Float64, parts[5]);

    # return -
    return model
end
# ---- PRIVATE METHODS ABOVE HERE ------------------------------------------------------------------------------------- #

# ---- PUBLIC METHODS BELOW HERE -------------------------------------------------------------------------------------- #
"""
    build(model::Type{T}, edgemodels::Dict{Int64, MyGraphEdgeModel}) where T <: MyAbstractGraphModel

Build a graph model from a dictionary of edge models, where the graph model is a subtype of `MyAbstractGraphModel`.

### Arguments
- `model::Type{T}`: A graph model of type `T`, where `T` is a subtype of `MyAbstractGraphModel`.
- `edgemodels::Dict{Int64, MyGraphEdgeModel}`: A dictionary of edge models of type `MyGraphEdgeModel`.

### Returns
A populated graph model of type `T` where `T` is a subtype of `MyAbstractGraphModel`.
"""
function build(model::Type{T}, edgemodels::Dict{Int64, MyGraphEdgeModel}) where T <: MyAbstractGraphModel

    # build and empty graph model -
    graphmodel = model();
    nodes = Dict{Int64, MyGraphNodeModel}();
    edges = Dict{Tuple{Int64, Int64}, Tuple{Float64,Float64, Float64}}();
    edgesinverse = Dict{Int, Tuple{Int, Int}}();
    children = Dict{Int64, Set{Int64}}();

    # -- DO STUFF WITH NODES -------------------------------------------------- #
    # let's build a list of nodes ids -
    tmp_node_ids = Set{Int64}();
    for (_,v) ∈ edgemodels
        push!(tmp_node_ids, v.source);
        push!(tmp_node_ids, v.target);
    end
    list_of_node_ids = tmp_node_ids |> collect |> sort;

    # build the nodes models with the id's
    [nodes[id] = MyGraphNodeModel(id) for id ∈ list_of_node_ids];
    
    # compute the children of this node -
    # for id ∈ list_of_node_ids
    #     node = nodes[id];
    #     children[id] = _children(edges, node.id);
    # end
    # ------------------------------------------------------------------------- #
    
    # -- DO STUFF WITH EDGES -------------------------------------------------- #
    # build the edges dictionary (source, target) -> (cost, lower_bound_capacity, upper_bound_capacity
    for (_, v) ∈ edgemodels
        source_index = v.source;
        target_index = v.target;
        edges[(source_index, target_index)] = (v.cost, v.lower_bound_capacity, v.upper_bound_capacity);
    end

    # build the inverse edge dictionary edgeid -> (source, target)
    n = length(nodes);
    edgecounter = 1;
    for source ∈ 1:n
        for target ∈ 1:n
            if haskey(edges, (source, target)) == true
                edgesinverse[edgecounter] = (source, target);
                edgecounter += 1;
            end
        end
    end
    # ------------------------------------------------------------------------- #
    
    # add stuff to model -
    graphmodel.nodes = nodes;
    graphmodel.edges = edges;
    graphmodel.edgesinverse = edgesinverse;
    graphmodel.children = children;

    # return -
    return graphmodel;
end
# ---- PUBLIC METHODS ABOVE HERE -------------------------------------------------------------------------------------- #