defmodule Quizzy.Generator do
  alias Quizzy.Generator.IdGenerator
  alias Quizzy.Generator.Player
  alias Quizzy.Generator.Player.TypeOfPlayer
  alias Quizzy.Generator.Quiz
  alias Quizzy.Generator.Game
  alias Quizzy.Events.{QuizWasPublished}

  def generate({year, month}) do
    IdGenerator.start_link
    players = generate_players({year, month})

    quizzes = generate_quizzes(players)

    games = generate_games(players, quizzes)

    IdGenerator.stop

    players ++ quizzes ++ games
    |> Enum.flat_map(fn
      %{event: event} -> [event]
      %{events: events} -> events
      event -> [event]
    end)
    |> Enum.sort(&(Timex.compare(&1.meta.timestamp, &2.meta.timestamp) < 1))
  end

  def generate_players({year, month}) do
    []
    |> Enum.concat(Player.generate_players(TypeOfPlayer.early_adoption, &try_out_publish_never_play/0, {year, month}))
    |> Enum.concat(Player.generate_players(TypeOfPlayer.followers, &followers/0, {year, month}))
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

    fast_player =


    %TypeOfPlayer{
      quiz_publish_distribution: quiz_publish_distribution,
      quiz_playing_distribution: quiz_playing_distribution,
      answer_speed: 20,
      answer_correctness: 0.5
    }
  end

  defp followers do
    quiz_publish_distribution_picker = :rand.uniform

    quiz_publish_distribution = cond do
      quiz_publish_distribution_picker <= 0.9 -> TypeOfPlayer.never
      quiz_publish_distribution_picker <= 0.98 -> TypeOfPlayer.try_out
      quiz_publish_distribution_picker <= 0.99 -> TypeOfPlayer.dropping
      quiz_publish_distribution_picker <= 1 -> TypeOfPlayer.steady
    end

    quiz_playing_distribution_picker = :rand.uniform

    TypeOfPlayer.steady
    TypeOfPlayer.steady_player

    {quiz_playing_distribution, answer_speed, answer_correctness} = cond do
      quiz_playing_distribution_picker <= 0.4 -> {TypeOfPlayer.never_player, 20, 0.5}
      quiz_playing_distribution_picker <= 0.7 -> {TypeOfPlayer.try_out_player, 20, 0.5}
      quiz_playing_distribution_picker <= 0.9 -> {TypeOfPlayer.steady_small_player, 20, 0.5}
      quiz_playing_distribution_picker <= 0.98 -> {TypeOfPlayer.steady_player, 10, 0.7}
      quiz_playing_distribution_picker <= 1 -> {TypeOfPlayer.bot_always_player, 1, 0.9}
    end

    %TypeOfPlayer{
      quiz_publish_distribution: quiz_publish_distribution,
      quiz_playing_distribution: quiz_playing_distribution,
      answer_speed: answer_speed,
      answer_correctness: answer_correctness,
    }
  end
end
