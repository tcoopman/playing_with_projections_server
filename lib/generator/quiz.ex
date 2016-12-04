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

  @questions [
    "Who is your celebrity crush?",
    "He didn’t want to go to the dentist, yet he went anyway.",
    "I would have gotten the promotion, but my attendance wasn’t good enough.",
    "Malls are great places to shop; I can find everything I need under one roof.",
    "Tom got a small piece of pie.",
    "Rock music approaches at high velocity.",
    "I am happy to take your donation; any amount will be greatly appreciated.",
    "Sixty-Four comes asking for bread.",
    "We have a lot of rain in June.", "Sometimes, all you need to do is completely make an ass of yourself and laugh it off to realise that life isn’t so bad after all.",
    "My Mum tries to be cool by saying that she likes all the same things that I do.",
    "If Purple People Eaters are real… where do they find purple people to eat?",
    "A song can make or ruin a person’s day if they let it get to them.",
    "Hurry!",
    "The stranger officiates the meal.",
    "Wow, does that work?",
    "I currently have 4 windows open up… and I don’t know why.",
    "The memory we used to share is no longer coherent.",
    "Let me help you with your baggage.",
    "Don't step on the broken glass.",
    "She wrote him a long letter, but he didn't read it.",
    "I want more detailed information.",
    "How was the math test?",
    "Italy is my favorite country; in fact, I plan to spend two weeks there next year.",
    "I am never at home on Sundays.",
    "What was the person thinking when they discovered cow’s milk was fine for human consumption… and why did they do it in the first place!?",
    "The old apple revels in its authority.",
    "If I don’t like something, I’ll stay away from it.",
    "She works two jobs to make ends meet; at least, that was her reason for not having time to join us.",
    "I really want to go to work, but I am too sick to drive.",
    "A glittering gem is not enough.",
    "The river stole the gods.",
    "The quick brown fox jumps over the lazy dog.",
    "There was no ice cream in the freezer, nor did they have money to go to the store.",
    "I was very proud of my nickname throughout high school but today- I couldn’t be any different to what my nickname was.",
    "There were white out conditions in the town; subsequently, the roads were impassable.",
    "The clock within this blog and the clock on my laptop are 1 hour different from each other.",
    "Where do random thoughts come from?",
    "Writing a list of random sentences is harder than I initially thought it would be.",
    "The lake is a long way from here.",
    "Is it free?",
    "The mysterious diary records the voice.",
    "She advised him to come back at once.",
    "Yeah, I think it's a good environment for learning English.",
    "Someone I know recently combined Maple Syrup & buttered Popcorn thinking it would taste like caramel popcorn. It didn’t and they don’t recommend anyone else do it either.",
    "Joe made the sugar cookies; Susan decorated them.",
    "I will never be this young again. Ever. Oh damn… I just got older.",
    "She folded her handkerchief neatly.",
    "I am counting my calories, yet I really want dessert.",
    "I hear that Nancy is very pretty.",
    "I think I will buy the red car, or I will lease the blue one.",
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

    quiz_title = Util.rand_from_list(@quiz_titles)

    quiz = %QuizWasCreated{meta: meta, quiz_id: quiz_id, quiz_title: quiz_title, owner_id: owner_id}

    questions = generate_questions(quiz)
    publish = publish_quiz(quiz)

    [quiz] ++ questions ++ [publish]
  end

  defp generate_questions(%QuizWasCreated{meta: quiz_meta, quiz_id: quiz_id}) do
    number_of_questions = :rand.uniform(10)
    for n <- 0..number_of_questions do
      minutes_to_add = :rand.uniform(20)
      timestamp = Timex.add(quiz_meta.timestamp, Timex.Duration.from_minutes(minutes_to_add))
      question_id = UUID.uuid4()
      question = Util.rand_from_list(@questions)
      answer = answer_for_question(question)
      meta = Util.generate_meta(timestamp)
      %QuestionAddedToQuiz{
        meta: meta,
        question_id: question_id,
        quiz_id: quiz_meta.id,
        question: question,
        answer: answer
      }
    end
  end

  defp publish_quiz(%QuizWasCreated{meta: quiz_meta, quiz_id: quiz_id}) do
    timestamp = Timex.add(quiz_meta.timestamp, Timex.Duration.from_minutes(30))
    meta = Util.generate_meta(timestamp)
    %QuizWasPublished{meta: meta, quiz_id: quiz_id}
  end

  defp year_month(timestamp) do
   date = Timex.to_date(timestamp)
   year = date.year
   month = date.month

   {year, month}
  end

  defp answer_for_question(question) do
    :crypto.hash(:sha, question) |> Base.encode16 |> String.downcase
  end
end
