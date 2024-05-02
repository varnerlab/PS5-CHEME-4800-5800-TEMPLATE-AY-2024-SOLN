# ---- PRIVATE METHODS BELOW HERE ------------------------------------------------------------------------------------- #
function _children(edges::Dict{Tuple{Int64, Int64}, Tuple{Float64,Float64, Float64}}, id::Int64)::Set{Int64}
    
    # initialize -
    childrenset = Set{Int64}();
    
    # Dumb implementation - why?
    for (k, _) ∈ edges
        if k[1] == id
            push!(childrenset, k[2]);
        end
    end

    # return -
    return childrenset;
end
# ---- PRIVATE METHODS ABOVE HERE ------------------------------------------------------------------------------------- #

# ---- PUBLIC METHODS BELOW HERE -------------------------------------------------------------------------------------- #
"""
    function children(graph::T, node::MyGraphNodeModel) -> Set{Int64} where T <: MyAbstractGraphModel
"""
function children(graph::T, node::MyGraphNodeModel)::Set{Int64} where T <: MyAbstractGraphModel
    return graph.children[node.id];
end

"""
    weight(graph::T, source::Int64, target::Int64)::Float64 where T <: MyAbstractGraphModel

Returns the weight of the edge between the source and target nodes.

### Arguments
- `graph::T`: A graph model of type `T` where `T` is a subtype of `MyAbstractGraphModel`.
- `source::Int64`: The source node id.
- `target::Int64`: The target node id.

### Returns
- `Float64`: The weight of the edge between the source and target nodes.
"""
function weight(graph::T, source::Int64, target::Int64)::Float64 where T <: MyAbstractGraphModel
    return graph.edges[(source, target)];
end
# ---- PUBLIC METHODS ABOVE HERE -------------------------------------------------------------------------------------- #