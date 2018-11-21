defmodule Hangman.Game do

    defstruct(
        turns_left: 7,
        game_state: :initializing,
        letters: [],
        used: MapSet.new()
    ) 

    def new_game(word) do
        %Hangman.Game{ letters: word |> String.codepoints }
    end

    def new_game() do
        new_game(Dictionary.random_word())
    end

    def make_move(game = %{ game_state: state}, _) when state in [ :won, :lost ] do
        game
    end
   
    def make_move(game, guess)  do
        accept_move(game, guess, MapSet.member?(game.used, guess))
    end

    def tally(game) do
        %{
            game_state: game.game_state,
            turns_left: game.turns_left,
            letters: game.letters |> Enum.map(fn x -> if MapSet.member?(game.used, x), do: x, else: "_" end)
        }
    end

    ################

    defp accept_move(game, _, _already_used = true) do
        %Hangman.Game{ game | game_state: :already_used }
    end

    defp accept_move(game, guess, _already_used) do
        Map.put(game, :used, MapSet.put(game.used, guess))
        |> score_guess(Enum.member?(game.letters, guess))
    end

    defp score_guess(game, _good_guess = true) do
        new_state = MapSet.new(game.letters)
        |> MapSet.subset?(game.used)
        |> maybe_won()
        Map.put(game, :game_state, new_state)
    end

    defp score_guess(game = %{ turns_left: 1}, _not_good_guess) do
        Map.put(game, :game_state, :lost)
    end

    defp score_guess(game = %{ turns_left: turns_left}, _not_good_guess) do
        %{ game | turns_left: turns_left - 1, game_state: :bad_guess}
    end
    
    defp maybe_won(true), do: :won
    defp maybe_won(_), do: :good_guess
end