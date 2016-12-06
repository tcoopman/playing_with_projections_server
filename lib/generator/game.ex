defmodule Quizzy.Generator.Game do
  alias Quizzy.Generator.Util
  alias Quizzy.Events.{QuizWasPublished, GameWasOpened}

  def generate_games(quizzes, players) do
    Enum.flat_map(quizzes, fn
      %{type: type, events: events} ->
        events
        |> Enum.filter(fn
          %QuizWasPublished{} -> true
          _ -> false
        end)
        |> Enum.flat_map(&(open_games(type, &1)))
    end)
  end

  def open_games(type, %QuizWasPublished{meta: meta, quiz_id: quiz_id}) do
    date = Timex.to_date(meta.timestamp)
    year = date.year
    month = date.month

    distribution = Util.numbers_to_date_map(type.game_distribution, {year, month}, {2017, 01})

    distribution
    |> Map.keys
    |> Util.filter_from_distribution({year, month})
    |> Enum.flat_map(&(Util.generate_days(&1, Util.number_to_generate_for_date(distribution, &1))))
    |> Enum.filter(fn timestamp -> Timex.after?(timestamp, meta.timestamp) end)
    |> Enum.map(&(open_game(&1, quiz_id)))
  end

  def open_game(timestamp, quiz_id) do
    meta = Util.generate_meta(timestamp)
    game_id = UUID.uuid4()
    %GameWasOpened{meta: meta, quiz_id: quiz_id, game_id: game_id}
  end
end
