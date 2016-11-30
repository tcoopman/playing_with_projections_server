class NumberOfRegisteredPlayers
  def self.project(events)
    events.select{|e| e[:type] == 'PlayerHasRegistered'}.count
  end
end
