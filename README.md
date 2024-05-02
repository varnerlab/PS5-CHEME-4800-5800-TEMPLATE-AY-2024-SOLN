# Problem Set 5 (PS5): Solving the Assignment Problem
This problem set will familiarize students with the assignment problem and its solution using [Bipartite Graphs](https://en.wikipedia.org/wiki/Bipartite_graph) and [Linear Programming](https://en.wikipedia.org/wiki/Linear_programming). For background on the assignment problem, please refer to the [online class notes](https://varnerlab.github.io/CHEME-4800-5800-ComputingBook/unit-3-learning/lp.html#minimum-flow-problems).

## Tasks
1. Solve the assignment problem encoded in the [Bipartite.edgelist](data/Bipartite.edgelist) file using [Linear Programming](https://en.wikipedia.org/wiki/Linear_programming). 
    - Implement the missing codes in the [Factory.jl](src/Factory.jl) and [Solve.jl](src/Solve.jl) files. To solve the [Linear Programming](https://en.wikipedia.org/wiki/Linear_programming) problem, use the [JuMP package](https://jump.dev/JuMP.jl/stable/) and the [GLPK solver](https://jump.dev/GLPK.jl/stable/). Solve the assignment problem with `required = 3`. Make sure to include a check to ensure the solver's convergence.
    - To test your implementation, implement a test suite in the `testme_task_1.jl` file. The test suite should compare your implementation's output with the expected output; see the `testme_task_1.jl` file.
    - Add missing comments. For an example of what to include in your comments, please look at the [readedgesfile function](src/Files.jl) file.

