"""
    readedgesfile(filepath::String; comment::Char='#', 
        delim::Char=',') -> Dict{Int64,MyGraphEdgeModel}

Reads an edge file and returns a dictionary of edge models, where the `key` is the line number 
and the `value` is the edge model of type `MyGraphEdgeModel`.

### Arguments
- `filepath::String`: The path to the edge file.
- `comment::Char`: The character that denotes a comment line in the file. Default is `#`.
- `delim::Char`: The character that delimits the edge file. Default is `,`.

### Returns
- `Dict{Int64,MyGraphEdgeModel}`: A dictionary of edge models, where the `key` is the line number and 
    the `value` is the edge model of type `MyGraphEdgeModel`.
"""
function readedgesfile(filepath::String; comment::Char='#', 
    delim::Char=',')::Dict{Int64,MyGraphEdgeModel}

    # initialize
    edges = Dict{Int64,MyGraphEdgeModel}()
    linecounter = 0;
    
    # main -
    open(filepath, "r") do file # open a stream to the file
        for line ∈ eachline(file) # process each line in a file, one at a time
            
            # check: do we have comments?
            if (contains(line, comment) == true) || (isempty(line) == true)
                continue; # skip this line, and move to the next one
            end
            
            # split the line around the delimiter -
            parts = split(line, delim) .|> String
            if (length(parts) != 3)
                push!(parts, "1.0"); # add a default weight, if we need to
            end

            # build the edge model -
            edges[linecounter] = _build(MyGraphEdgeModel, parts, linecounter);

            # update the line counter -
            linecounter += 1;
        end
    end

    # return -
    return edges;
end