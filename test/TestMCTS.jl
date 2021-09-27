using Assignment2
using Test: @testset, @test
using Random: seed!

seed!(0)

@testset "MCTSTests" begin
    # Create a tree to use for these tests.
    b₀ = TicTacToeBoard()
    root = construct_search_tree(b₀, T = 0.1)

    @testset "CheckValidTree" begin
        # Walk tree with depth-first-search and check consistency.
        # Recursive implementation of depth-first-search.
        visited = Set()
        function dfs(n::Node)
            # Checks:
            # (1) Ensure that n is the parent of all its children.
            @test isempty(n.children) ||
                all(n == c.parent for (m, c) in n.children)

            # (2) Ensure that the number of episodes passing through this node
            #     is the sum of those for all children.
            @test isempty(n.children) ||
                (n != root &&
                n.num_episodes == 1 + sum(
                    c.num_episodes for (m, c) in n.children)) ||
                (n == root &&
                n.num_episodes == sum(
                    c.num_episodes for (m, c) in n.children))

            # (3) Ensure that the total value is the sum of those for all of
            #     this node's children.
            @test isempty(n.children) ||
                abs(n.total_value - sum(
                    c.total_value for (m, c) in n.children)) ≤ 1

            # Recursion. Make sure to mark as visited.
            for (m, c) in n.children
	              if !(c in visited)
                    push!(visited, c)
                    dfs(c)
                end
            end
        end

        # Run depth-first-search with checks on the root.
        dfs(root)
    end

    @testset "CheckFindLeaf" begin
        n = find_leaf(root, upper_confidence_strategy)
        @test isempty(n.children) ||
            length(n.children) < length(next_moves(n.b))
    end

    @testset "CheckReasonableMove" begin
        reasonable_first_moves = [
            TicTacToeMove(1, 1), TicTacToeMove(1, 3), TicTacToeMove(3, 1),
            TicTacToeMove(3, 3), TicTacToeMove(2, 2)
        ]

        # Find the UCT move and confirm it is reasonable.
        next_node = upper_confidence_strategy(root)
        @test only(next_node.b.Xs) in reasonable_first_moves
    end

    @testset "CheckMoreTimeIsBetter" begin
        # Helper function to return the result of playing MCTS with T = T1 vs.
        # MCTS with T = T2.
        function play_game(; T1, T2)
            b = TicTacToeBoard()

            result = 0
            while true
                # P1 turn.
                root = construct_search_tree(b, T = T1)
                b = upper_confidence_strategy(root).b

                over, result = is_over(b)
                if over
                    break
                end

                # P2 turn.
                root = construct_search_tree(b, T = T2)
                b = upper_confidence_strategy(root).b

                over, result = is_over(b)
                if over
                    break
                end
            end

            return result
        end

        # Run a bunch of tests to confirm that the player with more time wins.
        total_value1 = 0
        total_value2 = 0
        for ii in 1:100
            total_value1 += play_game(T1 = 0.01, T2 = 0.001)
            total_value2 += play_game(T1 = 0.001, T2 = 0.01)
        end

        @test total_value1 < 0
        @test total_value2 > 0
    end
end
