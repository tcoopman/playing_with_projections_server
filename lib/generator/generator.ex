defmodule Quizzy.Generator do
  alias Quizzy.Generator.Player
  alias Quizzy.Generator.Player.EarlyAdopter
  alias Quizzy.Generator.Quiz
  alias Quizzy.Generator.Game
  alias Quizzy.Events.{QuizWasPublished}

  def generate({year, month}) do
    players = generate_players({year, month})

    quizzes = generate_quizzes(players)

    games = generate_games(players, quizzes)

    IO.inspect games

    players ++ quizzes ++ games
    |> Enum.flat_map(fn
      %{event: event} -> [event]
      %{events: events} -> events
      event -> [event]
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
    Game.generate_games(quizzes, players)
  end
end
