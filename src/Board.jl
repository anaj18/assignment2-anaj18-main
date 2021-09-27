# Abstract types for Board and Move.
# NOTE: in this assignment we will assume that the game being played has
#       two players and that outcomes of the game are
#       P1 win (P2 loss), P1 loss (P2 win), tie.
abstract type Board end
export Board

abstract type Move end
export Move

# Specialization of Move to TicTacToe.
struct TicTacToeMove <: Move
    row::Int
    col::Int
end # struct
export TicTacToeMove

# A Board specialized for TicTacToe. Stores locations of the Xs and Os as
# tuples of integers. Presuming that X plays first, the size of these lists
# determines which player's turn it is.
mutable struct TicTacToeBoard <: Board
    Xs::AbstractArray{TicTacToeMove}
    Os::AbstractArray{TicTacToeMove}
end # struct

# Custom initialization to empty.
TicTacToeBoard() = TicTacToeBoard([], [])
export TicTacToeBoard

# Enumerate all possible next moves.
# TODO! Implement this function.
function next_moves(b)

    all = TicTacToeMove(0, 0);
    for i in 1:3 
        for j in 1:3
            all = [all; TicTacToeMove(i, j)];
        end
    end
    next= setdiff(all, b.Xs)
    new= setdiff(next, b.Os)
    new = new[2:end]
    return new 
end
export next_moves


# Check if the given board is legal.
# TODO! Implement this function.
function is_legal(b)
    val = true
    size_x = length(b.Xs)
    size_o = length(b.Os)
    #next = next_moves(b)
    #Out of Bounds
    for i in 1:size_x
        if b.Xs[i].row > 3 || b.Xs[i].col > 3
            val = false
        end
    end
    for i in 1:size_o
        if b.Os[i].row > 3 || b.Os[i].col > 3
            val = false
        end
    end
    #Repeated Moves
    concat= [b.Xs; b.Os]
    uni= unique(concat)
    if uni != concat
        val = false
    end
    #Unbalanced Moves
    if size_x < size_o
        val = false
    end
    return val 
end
export is_legal

# Which player is up?
# TODO! Implement this function.
function up_next(b)
    size_x = length(b.Xs)
    size_o = length(b.Os)
    #value is 1 if x has to go and 0 if o has to go
    val = 1
    if size_x > size_o
        val = 0
    end 
    return val
end
export up_next

# Check if the game is over. If it is over, returns the outcome.
# TODO! Implement this function.
function is_over(b)
    size_x = length(b.Xs)
    size_o = length(b.Os)
    over = false
    # result is -1 if the computer wins, 0 for tie, and 
    #1 if the player wins.  
    result = 0 
    if (size_x + size_o) >= 5
        #making one array of all x row numbers 
        rowx_array = b.Xs[1].row
        for i in 2:size_x
            rowx_array = [rowx_array; b.Xs[i].row] 
        end
        #rowx_array = rowx_array[2:end]
        #checking if any of the x row values are the same
        for i in 1:3 
            if (length(findall(x-> x== i, rowx_array)) == 3)
                over = true 
                result = -1
            end
        end
        
        #making one array of all x column numbers 
        colx_array = b.Xs[1].col
        for i in 2:size_x
            colx_array = [colx_array; b.Xs[i].col] 
        end

        #checking if any of the x row values are the same
        for i in 1:3 
            if (length(findall(x-> x== i, colx_array)) == 3)
                over = true 
                result = -1
            end
        end

        #checking for diagonal xs 
        #Make a loop going through all of the possible values and checking if those are in b.Xs
        p1=TicTacToeMove(1, 1)
        p2=TicTacToeMove(2, 2)
        p3=TicTacToeMove(3, 3)
        p4=TicTacToeMove(1, 3)
        p5=TicTacToeMove(3, 1) 
        #checking if Xs has the main diagonal       
        if ((p1 ∈ b.Xs) && (p2 ∈ b.Xs) && (p3 ∈ b.Xs))
            over = true
            result = -1
        end
        #checking if Xs has the anti diagonal   
        if ((p2 ∈ b.Xs) && (p4 ∈ b.Xs) && (p5 ∈ b.Xs))
            over = true
            result = -1
        end
        
        #making one array of all o row numbers 
        rowo_array = b.Os[1].row
        for i in 2:size_o
            rowo_array = [rowo_array; b.Os[i].row] 
        end
        #rowo_array = rowo_array[2:end]
        #checking if any of the x row values are the same
        for i in 1:3 
            if (length(findall(x-> x== i, rowo_array)) == 3)
                over = true 
                result = 1
            end
        end
        
        #making one array of all o column numbers 
        colo_array = b.Os[1].col
        for i in 2:size_o
            colo_array = [colo_array; b.Os[i].col] 
        end
        #colo_array = colo_array[2:end]
        #checking if any of the x row values are the same
        for i in 1:3 
            if (length(findall(x-> x== i, colo_array)) == 3)
                over = true 
                result = 1
            end
        end

        #checking if Os has the main diagonal       
        if ((p1 ∈ b.Os) && (p2 ∈ b.Os) && (p3 ∈ b.Os))
            over = true
            result = 1
        end
        #checking if Os has the anti diagonal   
        if ((p2 ∈ b.Os) && (p4 ∈ b.Os) && (p5 ∈ b.Os))
            over = true
            result = 1
        end
        if (size_x + size_o) == 9
            over = true
        end
    end
    ans= over, result
    return ans 
end
export is_over

# Utility for printing boards out to the terminal.
function Base.show(io::IO, b::TicTacToeBoard)
    for ii in 1:3
        for jj in 1:3
            m = TicTacToeMove(ii, jj)
            if m ∈ b.Xs
                print(" X ")
            elseif m ∈ b.Os
                print(" O ")
            else
                print(" - ")
            end
        end

        println()
    end
end
