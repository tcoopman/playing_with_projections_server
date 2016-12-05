defmodule Quizzy.Generator do
  alias Quizzy.Generator.Player
  alias Quizzy.Generator.Player.EarlyAdopter
  alias Quizzy.Generator.Quiz
  alias Quizzy.Generator.Game
  alias Quizzy.Events.{QuizWasPublished}

  def generate({year, month}) do
    players = generate_players({year, month})

    quizzes = generate_quizzes(players)

    players ++ quizzes
    |> Enum.map(fn
      %{event: event} -> event
    end)
  end

  def generate_players({year, month}) do
    []
    |> Enum.concat(Player.generate_players(EarlyAdopter, {year, month}))
  end

  def generate_quizzes(players) do
    Enum.flat_map(players, &(Quiz.generate_quizzes(&1)))
  end

  def generate_games(players, quizzes) do
    quizzes
    |> Enum.filter(fn
      %QuizWasPublished{} -> true
      _ -> false
    end)
    |> Enum.flat_map(&(Game.generate_games(&1, players)))
  end
end
