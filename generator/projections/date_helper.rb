require 'date'

module DateHelper
  def month_of(quiz)
    if quiz.timestamp.kind_of?(DateTime)
      date = quiz.timestamp
    else
      date = DateTime.parse(quiz.timestamp)
    end
    "#{date.month}/#{date.year}"
  end
end