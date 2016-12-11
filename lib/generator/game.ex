defmodule Quizzy.Generator.Game do
  alias Quizzy.Generator.Player.TypeOfPlayer
  alias Quizzy.Generator.Util
  alias Quizzy.Generator.Quiz
  alias Quizzy.Events.{
    AnswerWasGiven,
    GameWasOpened,
    GameWasStarted,
    GameWasCancelled,
    GameWasFinished,
    PlayerHasRegistered,
    PlayerJoinedGame,
    QuestionAddedToQuiz,
    QuestionWasAsked,
    QuestionWasCompleted,
    QuizWasPublished,
    TimerHasExpired
  }

  def generate_games(quizzes, all_registered_players) do
    opened_games = Enum.flat_map(quizzes, fn
      %{type: type, events: events} ->
        events
        |> Enum.filter(fn
          %QuizWasPublished{} -> true
          _ -> false
        end)
        |> Enum.flat_map(&(open_games(type, &1)))
    end)

    played_games = opened_games
    |> Enum.flat_map(fn {questions, opened_game} ->
      possible_players = filter_players(opened_game, all_registered_players)

      joined_players = join_game(opened_game, possible_players)

      if (Enum.empty?(joined_players)) do
        game_was_cancelled_meta = Util.generate_meta(Timex.add(opened_game.meta.timestamp, Timex.Duration.from_minutes(10)))
        [%GameWasCancelled{meta: game_was_cancelled_meta, game_id: opened_game.game_id}]
      else
        game_was_started_meta = Util.generate_meta(Timex.add(opened_game.meta.timestamp, Timex.Duration.from_minutes(10)))
        game_was_started = %GameWasStarted{meta: game_was_started_meta, game_id: opened_game.game_id}

        game_played_events = play_game(game_was_started_meta.timestamp, opened_game.game_id, joined_players, questions)
        joined_player_events = Enum.map(joined_players, fn {type, event} -> event end)

        joined_player_events ++ [game_was_started] ++ game_played_events
      end

    end)

    opened_games_events = Enum.map(opened_games, fn {_, opened_game} -> opened_game end)

    opened_games_events ++ played_games
  end

  def open_games(type, %QuizWasPublished{meta: meta, quiz_id: quiz_id, secret_questions: secret_questions}) do
    date = Timex.to_date(meta.timestamp)
    year = date.year
    month = date.month

    distribution = Util.numbers_to_date_map(type.game_distribution, {year, month}, {2017, 01})

    distribution
    |> Map.keys
    |> Util.filter_from_distribution({year, month})
    |> Enum.flat_map(&(Util.generate_days(&1, Util.number_to_generate_for_date(distribution, &1))))
    |> Enum.filter(fn timestamp -> Timex.after?(timestamp, meta.timestamp) end)
    |> Enum.map(&({secret_questions, open_game(&1, quiz_id)}))
  end

  def open_game(timestamp, quiz_id) do
    meta = Util.generate_meta(timestamp)
    game_id = Util.generate_id
    %GameWasOpened{meta: meta, quiz_id: quiz_id, game_id: game_id}
  end

  defp filter_players(%GameWasOpened{meta: %{timestamp: game_opened_timestamp}}, registered_players) do
    Enum.filter(registered_players,
      fn %{event: %PlayerHasRegistered{meta: %{timestamp: player_registered_timestamp}}} ->
        Timex.after?(game_opened_timestamp, player_registered_timestamp)
      end)
  end

  defp join_game(%GameWasOpened{meta: meta, game_id: game_id}, players) do
    year_month_game_opened = Util.year_month(meta.timestamp)

    players
    |> Enum.map(fn
      %{type: %TypeOfPlayer{quiz_playing_distribution: quiz_playing_distribution} = type_of_player, event: %PlayerHasRegistered{meta: player_registered_meta, player_id: player_id}} ->
        year_month_player_joined = Util.year_month(player_registered_meta.timestamp)
        quiz_playing_distribution_dates = Util.numbers_to_date_map(quiz_playing_distribution, year_month_player_joined, {2017, 01})

        chance_of_playing_in_this_month = Map.get(quiz_playing_distribution_dates, year_month_game_opened, 0)
        if :rand.uniform < chance_of_playing_in_this_month do
          timestamp = Util.random_timestamp_after_minutes(meta.timestamp, 5)
          joined_meta = Util.generate_meta(timestamp)
          {type_of_player, %PlayerJoinedGame{meta: joined_meta, game_id: game_id, player_id: player_id}}
        else
          nil
        end
    end)
    |> Enum.filter(&(&1 != nil))
  end

  defp play_game(game_was_started_timestamp, game_id, players, questions) do
    played_game_events = questions
    |> Enum.with_index
    |> Enum.flat_map(fn
        {%QuestionAddedToQuiz{question_id: question_id, answer: answer}, index} ->
          offset_from_start = Timex.Duration.from_seconds(10 + 30 * index)
          question_asked_timestamp = Timex.add(game_was_started_timestamp, offset_from_start)

          question_asked = %QuestionWasAsked{meta: Util.generate_meta(question_asked_timestamp), game_id: game_id, question_id: question_id}

          answers = give_answers(question_asked, answer, players)

          question_completion_timestamp = Timex.add(question_asked_timestamp, Timex.Duration.from_seconds(30))
          question_completed = %QuestionWasCompleted{meta: Util.generate_meta(question_completion_timestamp), game_id: game_id, question_id: question_id}

          [question_asked] ++ answers ++ [question_completed]
    end)


    end_of_game_offset = Timex.Duration.from_seconds(10 + 30 * Enum.count(questions))
    game_finished_timestamp = Timex.add(game_was_started_timestamp, end_of_game_offset)
    game_finished = %GameWasFinished{meta: Util.generate_meta(game_finished_timestamp), game_id: game_id}

    played_game_events ++ [game_finished]
  end


  defp give_answers(
       %QuestionWasAsked{meta: question_asked_meta, game_id: game_id, question_id: question_id},
       correct_answer,
       players) do
  players
  |> Enum.map(fn
    {%TypeOfPlayer{answer_speed: answer_speed, answer_correctness: answer_correctness}, %PlayerJoinedGame{player_id: player_id}} ->
      case answer_or_timeout(question_asked_meta.timestamp, answer_speed) do
        {:timeout, timestamp} ->
          %TimerHasExpired{meta: Util.generate_meta(timestamp), game_id: game_id, question_id: question_id, player_id: player_id}
        {:answer, timestamp} ->
          answer = generate_answer(correct_answer, answer_correctness)
          %AnswerWasGiven{meta: Util.generate_meta(timestamp), game_id: game_id, question_id: question_id, answer: answer, player_id: player_id}
      end
  end)
  end

  defp answer_or_timeout(question_timestamp, answer_speed) do
    answer_time = answer_speed + (:rand.normal * answer_speed/2)
    answer_time = if answer_time < 0, do: 0, else: answer_time

    minimum_delay = 0.5
    real_answer_time = minimum_delay + answer_time

    if real_answer_time < 30 do
      {:answer, Timex.add(question_timestamp, Timex.Duration.from_seconds(real_answer_time))}
    else
      {:timeout, Timex.add(question_timestamp, Timex.Duration.from_seconds(30))}
    end
  end

  defp generate_answer(correct_answer, answer_correctness) do
    answer_chance = :rand.uniform

    incorrect_answer = Float.to_string(answer_chance)

    if :rand.uniform <= answer_correctness do
      correct_answer
    else
      Quiz.answer_for_question(incorrect_answer)
    end
  end
end
