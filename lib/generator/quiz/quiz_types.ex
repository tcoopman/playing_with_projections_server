defmodule Quizzy.Generator.Quiz.Popular do
    def game_distribution do
      [5, 10, 15, 17, 19, 17, 15, 13, 11, 9, 7, 5, 5, 4, 4, 3, 3, 2, 2, 2, 2, 1, 1, 1]
    end
end

defmodule Quizzy.Generator.Quiz.OneHitWonder do
    def game_distribution do
      [15, 25, 5]
    end
end

defmodule Quizzy.Generator.Quiz.NoPlayers do
    def game_distribution do
      []
    end
end

defmodule Quizzy.Generator.Quiz.SinglePlay do
  def game_distribution do
    [1]
  end
end

defmodule Quizzy.Generator.Quiz.Niche do
    def game_distribution do
      Enum.map(1..37, fn _ -> 1 end)
    end
end
