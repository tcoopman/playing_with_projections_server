class NumberOfRegisteredPlayersPerMonth
  def self.project(events)
    events.select{|e| e[:type] == 'PlayerHasRegistered'}.inject({}) do |accumulator, event|
      month = month_of(event)
      accumulator[month] ||= 0
      accumulator[month] += 1
      accumulator
    end.sort
  end

  def self.month_of(event)
    event[:timestamp].strftime('%Y_%m')
  end
end
