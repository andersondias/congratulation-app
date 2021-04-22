class SlackMessenger
  def spawn(*args)
    @@latest_spawn_parameter = args
  end

  def self.latest_spawn_parameter
    @@latest_spawn_parameter
  end
end
