# Construct a Monte Carlo search tree from the given board.
# Should accept an optional argument T which specifies the number of seconds
# spent in tree construction.
# For reference: https://en.wikipedia.org/wiki/Monte_Carlo_tree_search
# TODO! Implement this function.

#For time increments just look up julia time clock 
#using CPUTime
function construct_search_tree(b; T= 1)
    root = Node(b)
    #i=0

    #This function takes in a certified leaf which means
    #there are for sure potential children
    #Once run, this will add a child to the leaf from which 
    #we can simulate and then backpropogate
    function add(root_leaf)
        #println("This is what the parent looks like", root_leaf)
        b=root_leaf.b
        #println("This is the current state of the board", b)
        pos_matrix = next_moves(b)
        move = rand(pos_matrix)
        #println("This is the next random move that has been picked")
        #pop!(pos_matrix, move)
        filter!(x-> x≠move, pos_matrix)
        b1 = deepcopy(b)
        if up_next(b) == 1
            push!(b1.Xs, move)
            #println("It was Xs turn and the board now looks like this", b1)
        else 
            push!(b1.Os, move)
            #println("It was Os turn and the board now looks like this", b1)
        end
        child= Node(b1, root_leaf, Dict(), 0.0, 0)

        #println("This is what the child node looks like", child)
        #println("This is what the move looks like", move)
        #println("This is what the children look like before the new one is added", root.children)
        # new_dict = root_leaf.children        
        # new_dict[move]=child
        #root_leaf.children[move] = child
        #println("After adding, this is what the child of the parent node looks like", root_leaf.children)
        #chi = root_leaf.children[move]
        #val = [v for (k, v) in root_leaf.children]
        #merge!(root_leaf.children, Dict(move => child))
        #println("This is what the child node looks like Pt. 2", val)
        #println("This is what the parent node looks like", root_leaf)
        return child, move
    end
    
    t=0

    while t < T    
        t += @elapsed begin
            #println("Value of t is", t)
            #println("Root board is", root.b)
            leaf = find_leaf(root, upper_confidence_strategy)
            #println("Next step is adding now")
            #if !is_over(root.b)[1]    
            #println("Value of t is", t) 
            #println("Value of t is", t)   
            child_added, move = add(leaf)
            #move = add(leaf)[2]
            #println("This should be the state of the root node now 1", root)
            #println("This is the child that has been added", child_added)
            #println("This should be the state of the root node now 2", root)
            root.children[move] = child_added
            #backpropogate will only be run on a child that has 
            #just been added 
            #println("Value of t is", t)
            #println("Next step is simulating the added child now")
            #println("This should be the state of the root now 3", root)
            result = simulate(child_added)
            #println("This should be the state of the root now 4", root)
            #println("Value of t is", t)
            #println("Next step is backpropogating now")
            #println("This is the board of the child being backpropogated", child_added1.b)
            backpropagate!(child_added, result)
            #println("This should be the state of the board now 5", root)
        end
    end
    return root
end
export construct_search_tree



# Upper confidence strategy. Takes in a set of Nodes and returns one
# consistent with the UCT rule (see earlier reference for details).
# TODO! Implement this function.
#this will calculate values for each child and say which one is best

function upper_confidence_strategy(root)
    #has to return a node which will be chosen for the next step
    b = root.b
    parent = root.parent
    children = root.children
    tot_val = root.total_value
    epi = root.num_episodes
    tot = 0
    #Root only comes into this function if it has all possible children
    #Therefore is not a leaf
    #val = collect(values(children))
    val = [v for (k, v) in children]
    c= sqrt(2) 
        if up_next(b) == 1  
            for i in 1:length(val)
                vector = val[i]     
                form = vector.total_value/vector.num_episodes - c*sqrt(log(epi)/vector.num_episodes)   
                tot = [tot, form]     
            end
            #tot is now a list of final values of the particular node
            tot = tot[2:end]
            #pop![tot, 0]
            #index = findmin(tot)[2]
            ans = findmin(tot)[2]
        else
            for i in 1:length(val)
                vector = val[i]
                form = vector.total_value/vector.num_episodes + c*sqrt(log(epi)/vector.num_episodes)   
                tot = [tot; form]     
            end
            #tot is now a list of final values of the particular node
            tot = tot[2:end]
            #index = findmmax(tot)[2]
            ans = findmax(tot)[2]
        end
        ans1 = val[ans]
        return ans1    
end
export upper_confidence_strategy

# Walk the tree to find a leaf Node, choosing children at each level according
# to the function provided, whose signature is Foo(Node)::Node,
# such as the upper_confidence_strategy.
# TODO! Implement this function.
#To find a leaf use the Dict stuff and compare it to the next possible moves
function find_leaf(root, upper_confidence_strategy)
    b = root.b
    children = root.children
    tot_val = root.total_value
    next =  next_moves(b)
    move = [k for (k, v) in children]
    #println("Existing children are", move)
    #println("Possible next moves are", next)
    if !isempty(setdiff(next, move)) 
        leaf = root
        #println("set diff of next and moves is not empty")
    else
        #if is_over(b)[1] == false
        leaf = upper_confidence_strategy(root)
        #println("Upper confidence strategy used. So the node was not a leaf... right?")
    end
    #println("The leaf should look like this", leaf)
    return leaf 
end
export find_leaf

# Simulate gameplay from the given (leaf) node.
# TODO! Implement this function.
function simulate(root)
    fake_node = deepcopy(root)
    b = fake_node.b
    parent = fake_node.parent
    children = fake_node.children
    tot_val = fake_node.total_value
    epi = fake_node.num_episodes
    #println("Current Board is")
    #println(root.b)
    
    while is_over(b)[1] == false
        #println("Here the board is not over")
        #This is your next move
        next = rand(next_moves(b))
        #println("This will be the next random move", next)
        #Now seeing which player to add it to 
        if up_next(b) == 1
            b.Xs = [b.Xs; next]
            #println("move added to X and it looks like this now", b.Xs)
        else
            b.Os = [b.Os; next]
            #println("move added to O and it looks like this now", b.Os)
        end 
        #println("This is what the board looks like now", b)
    end
    result = is_over(b)[2]
    #println("This is what the board looks like", b)
    #println("This is what simulate finally gave out", result)
    #println(result)
    return result 
end
export simulate

# Backpropagate values up the tree from the given (leaf) node.
# TODO! Implement this function.
#this will calculate all the uct values for each node 
#backpropogate will only be run on a child that has 
#just been added 
function backpropagate!(root, result)
    b = root.b
    #println("Board being backpropogated is", b)
    parent = root.parent
    children = root.children
    tot_val = root.total_value
    #println("Total value of this child node is", tot_val)
    epi = root.num_episodes
    #println("# of episodes of this child node is", epi)
    #result = simulate(root)
    root.num_episodes = 1 + root.num_episodes
    #println("New number of episodes for the child node is ", root.num_episodes)
    root.total_value = result + root.total_value
    #println("Total value for the child node is ", root.total_value)
    while root.parent !== nothing 
        #println("Child node has a parent")
        root = root.parent
        #println("Current node board being looked at is", root.b)
        root.num_episodes = 1 + root.num_episodes
        #println("This has this many episodes so far", root.num_episodes)
        root.total_value = result + root.total_value
        #println("This has a total value of", root.num_episodes)
        #root = root.parent
    end 
    println("Outside while loop now. Final root board is", root.b)
    println("This has a total number of this many episodes: ", root.num_episodes)
end
export backpropagate!

# Play a game! Parameterized by time given to the CPU. Assumes CPU plays first.
export play_game
function play_game(; T = 0.1)
    println("Hello World")
    b = TicTacToeBoard()
    #println(b)
    result = 0
    println("This is the value of the result", result)
    while true
        # CPU's turn.
        #println("It is the CPU's turn")
        root = construct_search_tree(b, T = T)
        println("This is the result from construct tree search", root)
        b = upper_confidence_strategy(root).b

        # Display board.
        println(b)

        over, result = is_over(b)
        if over
            break
        end

        # Query user for move.
        println("Your move! Row = ?")
        row = parse(Int, readline())
        println("Column = ?")
        col = parse(Int, readline())

        # Construct next board state and repeat.
        m = TicTacToeMove(row, col)
        push!(b.Os, m)
        @assert is_legal(b)

        over, result = is_over(b)
        if over
            break
        end
    end

    println("Game over!")
    if result == -1
        println("I won!")
    elseif result == 0
        println("Tie game.")
    else
        println("You won.")
    end
end
