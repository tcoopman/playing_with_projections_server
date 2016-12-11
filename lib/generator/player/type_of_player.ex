defmodule Quizzy.Generator.Player.TypeOfPlayer do
  @enforce_keys [:quiz_publish_distribution, :quiz_playing_distribution, :answer_speed, :answer_correctness]
  defstruct [:quiz_publish_distribution, :quiz_playing_distribution, :answer_speed, :answer_correctness]

  # register distribution

  def early_adoption do
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

  def early_majority do
    %{
      {2014, 4}  => 20,
      {2014, 5}  => 15,
      {2014, 6}  => 10,
      {2014, 7}  => 5,
      {2014, 8}  => 5,
      {2014, 9}  => 5,
      {2014, 10}  => 5,
      {2014, 11}  => 5,
      {2014, 12}  => 5,
    }
  end

  def followers do
    %{
      {2014, 4}  => 20,
      {2014, 5}  => 15,
      {2014, 6}  => 10,
      {2014, 7}  => 5,
      {2014, 8}  => 5,
      {2014, 9}  => 5,
      {2014, 10}  => 5,
      {2014, 11}  => 5,
      {2014, 12}  => 5,
    }
  end

  # end register distribution

  # quiz_publish_distribution
  def try_out, do: [5]
  def dropping, do: [5, 3, 1]
  def dropping_slowly, do: [5, 4, 3, 2, 1]
  def steady, do: Enum.map(1..37, const(2))
  def rising, do: Enum.map(1..37, &(&1))
  def never, do: []

  # play_game_distribution
  def steady_big_player, do: Enum.map(1..37, const(20))
  def steady_player, do: Enum.map(1..37, const(10))
  def steady_small_player, do: Enum.map(1..37, const(2))
  def try_out_player, do: [20, 5, 1]
  def never_player, do: []
  def targeting_campaign_succeeds do
    %{
      {2014, 1}  => 20,
      {2014, 2}  => 20,
      {2014, 3}  => 20,
      {2014, 4}  => 20,
      {2014, 5}  => 20,
      {2014, 6}  => 20,
      {2014, 7}  => 20,
      {2014, 8}  => 20,
      {2014, 9}  => 20,
      {2014, 10}  => 20,
      {2014, 11}  => 20,
      {2014, 12}  => 20,
      {2015, 1}  => 20,
      {2015, 2}  => 20,
      {2015, 3}  => 20,
      {2015, 4}  => 0,
      {2015, 5}  => 0,
      {2015, 6}  => 0,
      {2015, 7}  => 0,
      {2015, 8}  => 0,
      {2015, 9}  => 0,
      {2015, 10}  => 0,
      {2015, 11}  => 0,
      {2015, 12}  => 0,
      {2016, 1}  => 0,
      {2016, 2}  => 0,
      {2016, 3}  => 40,
      {2016, 4}  => 40,
      {2016, 5}  => 40,
      {2016, 6}  => 30,
      {2016, 7}  => 40,
      {2016, 8}  => 30,
      {2016, 9}  => 20,
      {2016, 10}  => 20,
      {2016, 11}  => 20,
      {2016, 12}  => 20,
      {2017, 01}  => 20,
    }
  end
  def targeting_campaign_failed do
    %{
      {2014, 1}  => 20,
      {2014, 2}  => 20,
      {2014, 3}  => 20,
      {2014, 4}  => 20,
      {2014, 5}  => 20,
      {2014, 6}  => 20,
      {2014, 7}  => 20,
      {2014, 8}  => 20,
      {2014, 9}  => 20,
      {2014, 10}  => 20,
      {2014, 11}  => 20,
      {2014, 12}  => 20,
      {2015, 1}  => 20,
      {2015, 2}  => 20,
      {2015, 3}  => 20,
      {2015, 4}  => 0,
      {2015, 5}  => 0,
      {2015, 6}  => 0,
      {2015, 7}  => 0,
      {2015, 8}  => 0,
      {2015, 9}  => 0,
      {2015, 10}  => 0,
      {2015, 11}  => 0,
      {2015, 12}  => 0,
      {2016, 1}  => 0,
      {2016, 2}  => 0,
      {2016, 3}  => 0,
      {2016, 4}  => 0,
      {2016, 5}  => 0,
      {2016, 6}  => 0,
      {2016, 7}  => 0,
      {2016, 8}  => 0,
      {2016, 9}  => 0,
      {2016, 10}  => 0,
      {2016, 11}  => 0,
      {2016, 12}  => 0,
      {2017, 01}  => 0,
    }
  end

  def targeting_campaign_partly_succeeds do
    %{
      {2014, 1}  => 20,
      {2014, 2}  => 20,
      {2014, 3}  => 20,
      {2014, 4}  => 20,
      {2014, 5}  => 20,
      {2014, 6}  => 20,
      {2014, 7}  => 20,
      {2014, 8}  => 20,
      {2014, 9}  => 20,
      {2014, 10}  => 20,
      {2014, 11}  => 20,
      {2014, 12}  => 20,
      {2015, 1}  => 20,
      {2015, 2}  => 20,
      {2015, 3}  => 20,
      {2015, 4}  => 0,
      {2015, 5}  => 0,
      {2015, 6}  => 0,
      {2015, 7}  => 0,
      {2015, 8}  => 0,
      {2015, 9}  => 0,
      {2015, 10}  => 0,
      {2015, 11}  => 0,
      {2015, 12}  => 0,
      {2016, 1}  => 0,
      {2016, 2}  => 0,
      {2016, 3}  => 40,
      {2016, 4}  => 30,
      {2016, 5}  => 20,
      {2016, 6}  => 10,
      {2016, 7}  => 0,
      {2016, 8}  => 0,
      {2016, 9}  => 0,
      {2016, 10}  => 0,
      {2016, 11}  => 0,
      {2016, 12}  => 0,
      {2017, 01}  => 0,
    }
  end

  defp const(item), do: item
end
