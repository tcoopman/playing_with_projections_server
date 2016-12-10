defmodule Quizzy.Generator do
  alias Quizzy.Generator.Player
  alias Quizzy.Generator.Player.TypeOfPlayer
  alias Quizzy.Generator.Quiz
  alias Quizzy.Generator.Game
  alias Quizzy.Events.{QuizWasPublished}

  def generate({year, month}) do
    players = generate_players({year, month})

    quizzes = generate_quizzes(players)

    games = generate_games(players, quizzes)

    players ++ quizzes ++ games
    |> Enum.flat_map(fn
      %{event: event} -> [event]
      %{events: events} -> events
      event -> [event]
    end)
  end

  def generate_players({year, month}) do
    []
    |> Enum.concat(Player.generate_players(TypeOfPlayer.early_adoption, &try_out_publish_never_play/0, {year, month}))
  end

  def generate_quizzes(players) do
    Enum.flat_map(players, &(Quiz.generate_quizzes(&1)))
  end

  def generate_games(players, quizzes) do
    Game.generate_games(quizzes, players)
  end

  defp try_out_publish_never_play do
    quiz_publish_distribution_picker = :rand.uniform

    quiz_publish_distribution = cond do
      quiz_publish_distribution_picker <= 1 -> TypeOfPlayer.try_out
    end

    quiz_playing_distribution_picker = :rand.uniform

    quiz_playing_distribution = cond do
      quiz_playing_distribution_picker <= 0.8 -> TypeOfPlayer.never_player
      quiz_playing_distribution_picker <= 1 -> TypeOfPlayer.try_out_player
    end


    %TypeOfPlayer{
      quiz_publish_distribution: quiz_publish_distribution,
      quiz_playing_distribution: quiz_playing_distribution
    }
  end
end
