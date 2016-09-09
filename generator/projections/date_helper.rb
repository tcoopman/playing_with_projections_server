module DateHelper
  def month_of(quiz)
    date = DateTime.parse(quiz['timestamp'])
    "#{date.month}/#{date.year}"
  end
end