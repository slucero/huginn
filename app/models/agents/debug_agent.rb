module Agents
  class DebugAgent < Agent
    #cannot_be_scheduled!
    cannot_receive_events!

    default_schedule "midnight"

    description <<-MD
      The DebugAgent is useful for spawning events on command.
    MD

    event_description <<-MD
      Events look like this:
        
        {
          :test => "TESTING",
          :url => "http://www.google.com"
        }
    MD

    def check
      create_event :payload => options
    end

    def default_options
      {
        :test => "TESTING",
        :url => "http://www.google.com"
      }
    end

    # Implement me in your subclass to decide if your Agent is working.
    def working?
      return true;
    end
  end
end
