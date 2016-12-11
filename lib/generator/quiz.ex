defmodule Quizzy.Generator.Quiz do
  alias Quizzy.Generator.Player.TypeOfPlayer
  alias Quizzy.Generator.Util
  alias Quizzy.Generator.Quiz
  alias Quizzy.Events.{PlayerHasRegistered, QuizWasCreated, QuizWasPublished, QuestionAddedToQuiz}

  def generate_quizzes(%{type: %TypeOfPlayer{quiz_publish_distribution: quiz_publish_distribution}, event: %PlayerHasRegistered{} = event}) do
   {year, month} = Util.year_month(event.meta.timestamp)

   publish_distribution = Util.numbers_to_date_map(quiz_publish_distribution, {year, month}, {2017, 01})

   publish_distribution
   |> Map.keys
   |> Util.filter_from_distribution({year, month})
   |> Enum.flat_map(&(Util.generate_days(&1, Util.number_to_generate_for_date(publish_distribution, &1))))
   |> Enum.filter(fn timestamp -> Timex.after?(timestamp, event.meta.timestamp) end)
   |> Enum.map(&(generate_quiz(&1, event)))
  end

  defp generate_quiz(timestamp, event) do
    meta = Util.generate_meta(timestamp)
    quiz_id = Util.generate_id

    owner_id = event.player_id

    quiz_title = Util.hash_string(quiz_id) |> String.slice(0..4)

    quiz = %QuizWasCreated{meta: meta, quiz_id: quiz_id, quiz_title: quiz_title, owner_id: owner_id}

    questions = generate_questions(quiz)
    type_of_quiz = pick_type_of_quiz()

    events = if :rand.uniform > 0.1 do
      publish = publish_quiz(quiz, questions)

      [quiz] ++ questions ++ [publish]
    else
      [quiz] ++ questions
    end

    %{type: type_of_quiz, events: events}
  end

  defp generate_questions(%QuizWasCreated{meta: quiz_meta, quiz_id: quiz_id}) do
    number_of_questions = :rand.uniform(3)
    for _ <- 0..number_of_questions do
      minutes_to_add = :rand.uniform(20)
      timestamp = Timex.add(quiz_meta.timestamp, Timex.Duration.from_minutes(minutes_to_add))
      question_id = Util.generate_id
      question = Util.hash_string(question_id) |> String.slice(0..4)
      answer = answer_for_question(question)
      meta = Util.generate_meta(timestamp)
      %QuestionAddedToQuiz{
        meta: meta,
        question_id: question_id,
        quiz_id: quiz_id,
        question: question,
        answer: answer
      }
    end
  end

  defp publish_quiz(%QuizWasCreated{meta: quiz_meta, quiz_id: quiz_id}, questions) do
    timestamp = Timex.add(quiz_meta.timestamp, Timex.Duration.from_minutes(30))
    meta = Util.generate_meta(timestamp)

    %QuizWasPublished{meta: meta, quiz_id: quiz_id, secret_questions: questions}
  end

  def answer_for_question(question) do
    Util.hash_string(question) |> String.slice(0..4)
  end

  defp pick_type_of_quiz do
    distribution = :rand.uniform
    cond do
      distribution <= 0.5 -> Quiz.SinglePlay
      distribution <= 0.8 -> Quiz.OneHitWonder
      distribution <= 0.9 -> Quiz.NoPlayers
      distribution <= 0.95 -> Quiz.Popular
      distribution <= 1 -> Quiz.Niche
    end
  end
end
