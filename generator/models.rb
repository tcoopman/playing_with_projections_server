module Statistics
  class Player
    def self.generate(date_generator, iq_generator)
      Player.new(
          player_id: SecureRandom.uuid,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          registered_at: date_generator.rng,
          iq: iq_generator.rng
      )
    end

    include HashToFields
    include EventGenerator
    include TimeHelpers

    def initialize(options)
      @options = options
    end

    def events
      [
          generate_event('PlayerHasRegistered', registered_at, @options.except(:registered_at, :iq ))
      ]
    end

    def create_quizzes
      [
          quiz_1 = Quiz.generate(self, registered_at + a_few_minutes),
          Quiz.generate(self, quiz_1.published_at + a_few_seconds)
      ] + (1..4).map{ Quiz.generate(self, registered_at + a_few_days) }
    end
  end

  require_relative 'themes'
  class Quiz
    def self.generate(author, created_at)
      Quiz.new(
          author,
          quiz_id: SecureRandom.uuid,
          owner_id: author.player_id,
          created_at: created_at
      )
    end

    include HashToFields
    include EventGenerator
    include TimeHelpers

    attr_reader :author, :questions, :published_at

    def initialize(author, options)
      @author = author
      @options = options
      @theme = choose_theme
      @options[:quiz_title] = @theme.title
      @questions = (1..5).map{ Question.generate(self, @theme) }
      @published_at = @questions.max(&:created_at).created_at + a_few_minutes
    end

    def choose_theme
      [
          GameOfThronesTheme,
          StarWarsTheme,
          SuperheroTheme,
          PokemonTheme,
      ].sample.new
    end

    def events
      [
          generate_event('QuizWasCreated', created_at, @options.except(:created_at, :difficulty )),
          generate_event('QuizWasPublished', @published_at, quiz_id: quiz_id)
      ] + @questions.map(&:events)
    end

  end

  class Question
    def self.generate(quiz, theme)
      q_and_a = theme.question_and_answer
      Question.new(
                  quiz, theme,
          question_id: SecureRandom.uuid,
          quiz_id: quiz.quiz_id,
          question: q_and_a.first,
          answer: q_and_a.last,
          created_at: quiz.created_at + a_few_minutes,
          difficulty: quiz.author.iq
      )
    end

    include HashToFields
    include EventGenerator
    include TimeHelpers
    extend TimeHelpers

    def initialize(quiz, theme, options)
      @options = options
      @quiz = quiz
      @theme = theme
    end

    def wrong_answer
      @theme.question_and_answer.last
    end

    def events
      [
          generate_event('QuestionAddedToQuiz', created_at, @options.except(:created_at ))
      ]
    end
  end

  class Game
    def self.generate(quiz, players)
      Game.new(
          quiz,
          players,
          game_id: SecureRandom.uuid,
          quiz_id: quiz.quiz_id,
          opened_at: [players.map(&:registered_at), quiz.created_at].flatten.max + a_few_days
      )
    end

    include HashToFields
    include EventGenerator
    include TimeHelpers
    extend TimeHelpers

    attr_reader :started_at

    def initialize(quiz, players, options)
      @quiz = quiz
      @players = players
      @options = options

      @attendances = @players.map{|player| Attendance.new(self, player)}
      @started_at = @attendances.map(&:joined_at).max + a_second

      @question_rounds = @quiz.questions.map{|question| QuestionRound.new(self, question, @players)}
      @finished_at = @question_rounds.map(&:closed_at).max + a_second
    end

    def events
      [
          generate_event('GameWasOpened', opened_at, @options.except(:opened_at)),
          generate_event('GameWasStarted', @started_at, {game_id: game_id}),
          generate_event('GameWasFinished', @finished_at, {game_id: game_id})
      ] + @attendances.map(&:events) + @question_rounds.map(&:events)
    end
  end

  class Attendance
    include HashToFields
    include TimeHelpers
    include EventGenerator

    def initialize(game, player)
      @options = {
          joined_at: game.opened_at + a_few_seconds,
          player_id: player.player_id,
          game_id: game.game_id
      }
    end

    def events
      generate_event('PlayerJoinedGame', joined_at, @options.except(:joined_at))
    end
  end

  class QuestionRound
    include HashToFields
    include EventGenerator
    include TimeHelpers

    attr_reader :opened_at, :closed_at
    def initialize(game, question, players)
      @options ={
          game_id: game.game_id,
          question_id: question.question_id
      }

      #TODO: make question rounds follow each other cronologically
      @opened_at = game.started_at + a_few_minutes

      @answers = players.map{|player| Answer.new(question, self, player)}
      @closed_at = @answers.map(&:answered_at).max + a_second
    end

    def events
      [
          generate_event('QuestionWasOpened', @opened_at, @options),
          generate_event('QuestionWasClosed', @closed_at, @options)
      ] + @answers.map(&:events)
    end
  end

  class Answer
    include EventGenerator
    include HashToFields
    include TimeHelpers

    attr_reader :answered_at
    def initialize(question, question_round, player)
      @question = question
      @player = player
      answer = right_answer? ? question.answer : question.wrong_answer
      @options ={
          game_id: question_round.game_id,
          question_id: question_round.question_id,
          player_id: player.player_id,
          answer: answer
      }
      @answered_at = question_round.opened_at + a_few_seconds
    end

    def right_answer?
      @player.iq >= @question.difficulty
    end

    def events
      generate_event('AnswerWasGiven', @answered_at, @options)
    end
  end

end