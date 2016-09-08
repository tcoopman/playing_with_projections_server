module Statistics
  module HashToFields
    def method_missing *args
      @options[args.first]
    end
  end

  module EventGenerator
    def generate_event(type, timestamp, payload)
      {
          id: SecureRandom.uuid,
          type: type,
          timestamp: timestamp,
          payload: payload
      }
    end
  end

  module TimeHelpers
    def a_second
      a_minute / 60
    end

    def a_minute
      an_hour / 60
    end

    def an_hour
      a_day / 24
    end

    def a_day
      1.0
    end

    def a_few_seconds
      Random.new.rand(60.0) * a_second
    end

    def a_few_minutes
      Random.new.rand(10.0) * a_minute
    end

    def a_few_days
      Random.new.rand(15.0) * a_day
    end
  end
end
