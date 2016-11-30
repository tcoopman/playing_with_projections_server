require 'securerandom'

class EventGenerator
  def self.generate(event_type, timestamp, data)
    {
        id: SecureRandom.uuid,
        type: event_type,
        timestamp: timestamp,
        payload: self.send(event_type, data)
    }
  end

  def self.PlayerHasRegistered(data)
    player = data[:player]
    {
      first_name: player.first_name,
      last_name: player.last_name
    }
  end
end
