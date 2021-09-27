# Assignment 2: Building your own tic-tac-toe engine

In this assignment, you will implement a variant of Monte Carlo Tree Search (MCTS) and use it to play tic-tac-toe. By the end of this assignment you should:

- understand the nuts and bolts of extensive form in finite dynamic games
- be confident in your ability to compute optimal play in finite dynamic games with MCTS
- have become a confident Julia programmer and feel comfortable with more involved software design patterns

As in Assignment 1, some starter code is provided and the objective is to pass all unit tests in the `test/` directory. These tests will run automatically whenever you push a new commit. You can also check your implementation locally as described below. **Do not modify these tests in your `main` branch. If you feel you must, do so in a separate branch, open a Pull Request to `main`, and add me as a reviewer so that I can approve the changes.**

## Setup

As before, this assignment is structured as a Julia package. To activate this assignment's package, type
```console
julia> ]
(@v1.6) pkg> activate .
  Activating environment at `<path to repo>/Project.toml`
(Assignment1) pkg>
```
Now exit package mode by hitting the `[delete]` key. You should see the regular Julia REPL prompt. Type:
```console
julia> using Revise
julia> using Assignment2
```
You are now ready to start working on the assignment.

## Part 1: Tic-tac-toe board

In `src/Board.jl` you will find the skeleton implementation for a `TicTacToeBoard`, which contains a list of the locations of `X`s and `O`s. There are a number of missing functions which you must implement. These functions are utilities which underlie the construction of the MCTS search tree, and in effect constitute the dynamics of the game.

Implement these missing functions (marked with `TODO`).

## Part 2: MCTS

In `src/MCTS.jl` you will find an interface to guide your implementation of MCTS. Implement the missing functions (marked with `TODO`).

To try out your implementation, you can use the provided `play_game()` method in the REPL:
```console
julia> play_game()
```

## Autograde your work

Your work will be automatically graded every time you push a commit to GitHub. If you are not sure how to work with GitHub, I strongly recommend reading any of the short tutorial blogs available for getting up to speed, such as [this one](https://product.hubspot.com/blog/git-and-github-tutorial-for-beginners). As above: **Do not modify these tests in your `main` branch. If you feel you must, do so in a separate branch, open a Pull Request to `main`, and add me as a reviewer so that I can approve the changes.**

To run tests locally and avoid polluting your commit history, in the REPL you can type:
```console
julia> ]
(Assignment1) pkg> test
```

## Final note

In the auto-generated `Feedback` Pull Request, please briefly comment on (a) roughly how long this assignment took for you to complete, and (b) any specific suggestions for improving the assignment the next time the course is offered.
