defmodule Quizzy.Generator.Quiz do
  alias Quizzy.Generator.Util
  alias Quizzy.Events.{PlayerHasRegistered, QuizWasCreated, QuizWasPublished, QuestionAddedToQuiz}

  @quiz_titles [
    "Pokemon!",
    "Superpowers!",
    "Capitals of the world",
    "Presidents of America",
    "Best beers",
    "Wildlife",
    "Chess",
    "Type of clouds?",
    "Movies",
    "How many animals do you know?"
  ]

  def generate_quizzes(%{type: type, event: %PlayerHasRegistered{} = event}) do
   {year, month} = year_month(event.meta.timestamp)

   type.quiz_publish_distribution
   |> Map.keys
   |> Util.filter_from_distribution({year, month})
   |> Enum.flat_map(&(Util.generate_days(&1, Util.number_to_generate_for_date(type.quiz_publish_distribution, &1))))
   |> Enum.flat_map(&(generate_quiz(&1, event)))
   |> Enum.map(fn event -> %{type: type, event: event} end) # TODO type of quiz
  end

  defp generate_quiz(timestamp, event) do
    meta = Util.generate_meta(timestamp)
    quiz_id = UUID.uuid4()

    owner_id = event.player_id

    quiz_title = Enum.at(@quiz_titles, (:rand.uniform(10) -1))

    quiz = %QuizWasCreated{meta: meta, quiz_id: quiz_id, quiz_title: quiz_title, owner_id: owner_id}


    [quiz]
  end

  defp year_month(timestamp) do
   date = Timex.to_date(timestamp)
   year = date.year
   month = date.month

   {year, month}
  end
end
