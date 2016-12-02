class TopAuthors
  def self.project(events)
    authors = {}
    events.select{|event| event[:type] == 'QuizWasCreated'}.each do |quiz|
      if quiz[:payload][:author]
        authors[quiz[:payload][:author]] ||= 0
        authors[quiz[:payload][:author]] += 1
      end
    end

    authors.sort_by{|author, count| -count }.first(5)
  end
end
