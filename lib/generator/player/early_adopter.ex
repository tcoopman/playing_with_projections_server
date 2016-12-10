defmodule Quizzy.Generator.Player.EarlyAdopter do
  alias Quizzy.Events.{PlayerHasRegistered, Meta}

  @steady Enum.map(1..37, fn _ -> 2 end)
  @rising Enum.map(1..37, fn n -> n end)
  @dropping [10, 5, 2]
  @dropping_slowly [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
  @try_out [5]

  def register_distribution do
    %{
      {2014, 1}  => 15,
      {2014, 2}  => 20,
      {2014, 3}  => 25,
      {2014, 4}  => 20,
      {2014, 5}  => 15,
      {2014, 6}  => 10,
      {2014, 7}  => 5,
      {2014, 8}  => 5
    }
  end

  def quiz_publish_distribution do
    distribution = :rand.uniform
    cond do
      distribution <= 0.7 -> @try_out
      distribution <= 0.8 -> @dropping
      distribution <= 0.9 -> @dropping_slowly
      distribution <= 0.98 -> @steady
      distribution <= 1 -> @rising
    end
  end

  def chance_of_playing do
    #TODO don't add a type of player, but add all the metadata at generation. Like that we don't don't generate a new distribution every time
    #
    [0.05, 0.01, 0.001, 0]
  end
end
