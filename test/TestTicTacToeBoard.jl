using Assignment2
using Test: @test, @testset

@testset "TicTacToeBoardTests" begin
    @testset "CheckBoardClassification" begin
        @testset "OutOfBounds" begin
            Xs = [TicTacToeMove(1, 3), TicTacToeMove(2, 5)]
            Os = [TicTacToeMove(1, 2), TicTacToeMove(3, 1)]
            b = TicTacToeBoard(Xs, Os)
            @test !is_legal(b)
        end # testset

        @testset "RepeatedMove" begin
            Xs = [TicTacToeMove(1, 3), TicTacToeMove(1, 2)]
            Os = [TicTacToeMove(2, 2), TicTacToeMove(1, 3)]
            b = TicTacToeBoard(Xs, Os)
            @test !is_legal(b)
        end # testset

        @testset "UnbalancedMoves" begin
            Xs = [TicTacToeMove(1, 3), TicTacToeMove(1, 2)]
            Os = [TicTacToeMove(2, 2), TicTacToeMove(1, 3), TicTacToeMove(1, 1)]
            b = TicTacToeBoard(Xs, Os)
            @test !is_legal(b)
        end # testset

        @testset "LegalNonTerminal" begin
            Xs = [TicTacToeMove(1, 3), TicTacToeMove(1, 2)]
            Os = [TicTacToeMove(2, 2), TicTacToeMove(2, 3)]
            b = TicTacToeBoard(Xs, Os)
            @test is_legal(b)
            @test up_next(b) == 1

            over, result = is_over(b)
            @test !over
        end # testset

        @testset "LegalTerminal" begin
            Xs = [TicTacToeMove(1, 3), TicTacToeMove(1, 2), TicTacToeMove(1, 1)]
            Os = [TicTacToeMove(2, 2), TicTacToeMove(2, 3)]
            b = TicTacToeBoard(Xs, Os)
            @test is_legal(b)

            over, result = is_over(b)
            @test over
        end # testset
    end # testset

    # Check next moves from a given board.
    @testset "CheckNextMoves" begin
        Xs = [TicTacToeMove(1, 3), TicTacToeMove(1, 2)]
        Os = [TicTacToeMove(2, 2)]
        b = TicTacToeBoard(Xs, Os)

        moves = next_moves(b)
        correct_moves = [
            TicTacToeMove(1, 1), TicTacToeMove(2, 1), TicTacToeMove(2, 3),
            TicTacToeMove(3, 1), TicTacToeMove(3, 2), TicTacToeMove(3, 3)
        ]

        for m ∈ moves
            @test m ∈ correct_moves
        end

        for m̂ ∈ correct_moves
            @test m̂ ∈ moves
        end
    end # testset
end # testset
