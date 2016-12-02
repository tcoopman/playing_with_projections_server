defmodule Quizzy.Generator do
  alias Quizzy.Generator.Player
  alias Quizzy.Generator.Quiz
  alias Quizzy.Generator.Player.EarlyAdopter

  def generate() do
    players = generate_players()

    quizzes = generate_quizzes(players)
  end

  def generate_players() do
    []
    |> Enum.concat(Player.generate_players(EarlyAdopter, {2015, 2}))
  end

  def generate_quizzes(players) do
    Enum.map(players, &(Quiz.generate_quizzes(&1)))
  end

  def generate_games(players, quizzes) do

  end
end
