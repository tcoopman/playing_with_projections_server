defmodule Quizzy.Generator do
  alias Quizzy.Generator.Player
  alias Quizzy.Generator.Quiz
  alias Quizzy.Generator.Player.EarlyAdopter

  def generate() do
    players = generate_players()

    quizzes = generate_quizzes(players)

    players ++ quizzes

    players ++ quizzes
    |> Enum.map(fn
      %{event: event} -> event
    end)
  end

  def generate_players() do
    []
    |> Enum.concat(Player.generate_players(EarlyAdopter, {2017, 1}))
  end

  def generate_quizzes(players) do
    Enum.flat_map(players, &(Quiz.generate_quizzes(&1)))
  end

  def generate_games(players, quizzes) do

  end
end
