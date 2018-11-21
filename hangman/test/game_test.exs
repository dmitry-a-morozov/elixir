defmodule GameTest do
  use ExUnit.Case
  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    #assert game.letters |> Enum.all?(fn x -> x in ?a..?z end)
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [ :won, :lost ] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert game = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurrence of letter is not already used" do
    game = Game.new_game()
    game= Game.make_move(game, "x")
    assert game.game_state != :already_used
    game= Game.make_move(game, "x")
    assert game.game_state == :already_used  
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    game= Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7 
  end

  test "a guessed word is won a game" do
    game = Game.new_game("wibble")
    moves = [
      {"w", :good_guess}, 
      {"i", :good_guess}, 
      {"b", :good_guess}, 
      {"l", :good_guess}, 
      {"e", :won}
    ]

    Enum.reduce(moves, game, fn ({guess, state}, new_game) ->
      new_game = Game.make_move(new_game, guess)
      assert new_game.game_state == state
      new_game
    end)

  end

  test "bad guess is recognized" do
    game = Game.new_game("wibble")
    game= Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end  

  test "lost game is recognized" do
    moves = [
      { "a", :bad_guess, 6 },
      { "b", :bad_guess, 5 },
      { "c", :bad_guess, 4 },
      { "d", :bad_guess, 3 },
      { "e", :bad_guess, 2 },
      { "f", :bad_guess, 1 },
      { "g", :lost, 1 },
    ]

    game = Game.new_game("w")

    Enum.reduce(moves, game, fn ({ guess, state, turns_left }, game) -> 
      game = Game.make_move(game, guess)
      assert game.game_state == state
      assert game.turns_left == turns_left
      game
    end)
  end  

end
