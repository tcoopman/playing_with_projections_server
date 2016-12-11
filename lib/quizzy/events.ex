defmodule Quizzy.Events do
  @moduledoc """
  List of the quizzy domain events
  """
  defmodule Meta do
    @enforce_keys [:id, :timestamp]
    defstruct [:id, :timestamp]
  end

  defmodule QuizWasCreated do
    @enforce_keys [:meta, :quiz_id, :quiz_title, :owner_id]
    defstruct [:meta, :quiz_id, :quiz_title, :owner_id]
  end

  defmodule QuizWasPublished do
    @enforce_keys [:meta, :quiz_id]
    defstruct [:meta, :quiz_id, :secret_questions]
  end

  defmodule PlayerHasRegistered do
    @enforce_keys [:meta, :player_id, :first_name, :last_name]
    defstruct [:meta, :player_id, :first_name, :last_name]
  end

  defmodule QuestionAddedToQuiz do
    @enforce_keys [:meta, :question_id, :quiz_id, :question, :answer]
    defstruct [:meta, :question_id, :quiz_id, :question, :answer]
  end

  defmodule GameWasOpened do
    @enforce_keys [:meta, :quiz_id, :game_id]
    defstruct [:meta, :quiz_id, :game_id]
  end

  defmodule GameWasStarted do
    @enforce_keys [:meta, :game_id]
    defstruct [:meta, :game_id]
  end

  defmodule PlayerJoinedGame do
    @enforce_keys [:meta, :game_id, :player_id]
    defstruct [:meta, :game_id, :player_id]
  end

  defmodule PlayerLeftGame do
    @enforce_keys [:meta, :game_id, :player_id]
    defstruct [:meta, :game_id, :player_id]
  end

  defmodule QuestionWasAsked do
    @enforce_keys [:meta, :game_id, :question_id]
    defstruct [:meta, :game_id, :question_id]
  end

  defmodule AnswerWasGiven do
    @enforce_keys [:meta, :game_id, :question_id, :answer, :player_id]
    defstruct [:meta, :game_id, :question_id, :answer, :player_id]
  end

  defmodule TimerHasExpired do
    @enforce_keys [:meta, :game_id, :question_id, :player_id]
    defstruct [:meta, :game_id, :question_id, :player_id]
  end

  defmodule QuestionWasCompleted do
    @enforce_keys [:meta, :game_id, :question_id]
    defstruct [:meta, :game_id, :question_id]
  end

  defmodule GameWasFinished do
    @enforce_keys [:meta, :game_id]
    defstruct [:meta, :game_id]
  end

  defmodule GameWasCancelled do
    @enforce_keys [:meta, :game_id]
    defstruct [:meta, :game_id]
  end

  def event_to_json(%QuizWasCreated{meta: meta, quiz_id: quiz_id, quiz_title: quiz_title, owner_id: owner_id}) do
    %{type: "QuizWasCreated", id: meta.id, timestamp: meta.timestamp, payload: %{quiz_id: quiz_id, quiz_title: quiz_title, owner_id: owner_id}}
  end
  def event_to_json(%QuizWasPublished{meta: meta, quiz_id: quiz_id}) do
    %{type: "QuizWasPublished", id: meta.id, timestamp: meta.timestamp, payload: %{quiz_id: quiz_id}}
  end
  def event_to_json(%QuestionAddedToQuiz{meta: meta, quiz_id: quiz_id, question_id: question_id, question: question, answer: answer}) do
    %{type: "QuestionAddedToQuiz", id: meta.id, timestamp: meta.timestamp, payload: %{quiz_id: quiz_id, question_id: question_id, question: question, answer: answer}}
  end
  def event_to_json(%PlayerHasRegistered{meta: meta, first_name: first_name, last_name: last_name, player_id: player_id}) do
    %{type: "PlayerHasRegistered", id: meta.id, timestamp: meta.timestamp, payload: %{first_name: first_name, last_name: last_name, player_id: player_id}}
  end
  def event_to_json(%GameWasOpened{meta: meta, quiz_id: quiz_id, game_id: game_id}) do
    %{type: "GameWasOpened", id: meta.id, timestamp: meta.timestamp, payload: %{quiz_id: quiz_id, game_id: game_id}}
  end
  def event_to_json(%GameWasCancelled{meta: meta, game_id: game_id}) do
    %{type: "GameWasCancelled", id: meta.id, timestamp: meta.timestamp, payload: %{game_id: game_id}}
  end
  def event_to_json(%GameWasStarted{meta: meta, game_id: game_id}) do
    %{type: "GameWasStarted", id: meta.id, timestamp: meta.timestamp, payload: %{game_id: game_id}}
  end
  def event_to_json(%PlayerJoinedGame{meta: meta, game_id: game_id, player_id: player_id}) do
    %{type: "PlayerJoinedGame", id: meta.id, timestamp: meta.timestamp, payload: %{game_id: game_id, player_id: player_id}}
  end
  def event_to_json(%QuestionWasAsked{meta: meta, game_id: game_id, question_id: question_id}) do
    %{type: "QuestionWasAsked", id: meta.id, timestamp: meta.timestamp, payload: %{game_id: game_id, question_id: question_id}}
  end
  def event_to_json(%QuestionWasCompleted{meta: meta, game_id: game_id, question_id: question_id}) do
    %{type: "QuestionWasCompleted", id: meta.id, timestamp: meta.timestamp, payload: %{game_id: game_id, question_id: question_id}}
  end
  def event_to_json(%GameWasFinished{meta: meta, game_id: game_id}) do
    %{type: "GameWasFinished", id: meta.id, timestamp: meta.timestamp, payload: %{game_id: game_id}}
  end
  def event_to_json(%AnswerWasGiven{meta: meta, game_id: game_id, question_id: question_id, player_id: player_id, answer: answer}) do
    %{type: "AnswerWasGiven", id: meta.id, timestamp: meta.timestamp, payload: %{game_id: game_id, question_id: question_id, player_id: player_id, answer: answer}}
  end
  def event_to_json(%TimerHasExpired{meta: meta, game_id: game_id, question_id: question_id, player_id: player_id}) do
    %{type: "TimerHasExpired", id: meta.id, timestamp: meta.timestamp, payload: %{game_id: game_id, question_id: question_id, player_id: player_id}}
  end

  def json_to_event(%{type: type, id: id, timestamp: timestamp, payload: payload}) do
    case type do
        "QuizWasCreated" ->
            %QuizWasCreated{
                meta: meta(id, timestamp),
                  quiz_id: payload.quiz_id,
                quiz_title: payload.quiz_title,
                owner_id: payload.owner_id
            }
        "QuizWasPublished" ->
            %QuizWasPublished{
                meta: meta(id, timestamp),
                quiz_id: payload.quiz_id,
            }
        "PlayerHasRegistered" ->
            %PlayerHasRegistered{
                meta: meta(id, timestamp),
                first_name: payload.first_name,
                last_name: payload.last_name,
                player_id: payload.player_id
            }
        "QuestionAddedToQuiz" ->
            %QuestionAddedToQuiz{
                meta: meta(id, timestamp),
                quiz_id: payload.quiz_id,
                question_id: payload.question_id,
                question: payload.question,
                answer: payload.answer
            }
        "GameWasOpened" ->
            %GameWasOpened{
                meta: meta(id, timestamp),
                quiz_id: payload.quiz_id,
                game_id: payload.game_id
            }
        "GameWasStarted" ->
            %GameWasStarted{
                meta: meta(id, timestamp),
                game_id: payload.game_id
            }
        "PlayerJoinedGame" ->
            %PlayerJoinedGame{
                meta: meta(id, timestamp),
                game_id: payload.game_id,
                player_id: payload.player_id
            }
        "PlayerLeftGame" ->
            %PlayerLeftGame{
                meta: meta(id, timestamp),
                game_id: payload.game_id,
                player_id: payload.player_id
            }
        "QuestionWasAsked" ->
            %QuestionWasAsked{
                meta: meta(id, timestamp),
                game_id: payload.game_id,
                question_id: payload.question_id

            }
        "AnswerWasGiven" ->
            %AnswerWasGiven{
                meta: meta(id, timestamp),
                game_id: payload.game_id,
                question_id: payload.question_id,
                answer: payload.answer,
                player_id: payload.player_id
            }
        "TimerHasExpired" ->
            %TimerHasExpired{
                meta: meta(id, timestamp),
                game_id: payload.game_id,
                question_id: payload.question_id,
                player_id: payload.player_id
            }
        "QuestionWasCompleted" ->
            %QuestionWasCompleted{
                meta: meta(id, timestamp),
                game_id: payload.game_id,
                question_id: payload.question_id,
            }
        "GameWasFinished" ->
            %GameWasFinished{
                meta: meta(id, timestamp),
                game_id: payload.game_id,
            }
        "GameWasCancelled" ->
            %GameWasCancelled{
                meta: meta(id, timestamp),
                game_id: payload.game_id,
            }
    end
  end

  defp meta(id, timestamp) do
      %Meta{
          id: id,
          timestamp: timestamp
      }
  end
end
