module Agents
  class TemplateAgent < Agent
    cannot_be_scheduled!

    description <<-MD
      The TemplateAgent collects input from an input event and formats the values for use in other agents.
    MD

    event_description <<-MD
      Events look like this:  
        
        {
          :expected_receive_period_in_days => "2",
          :template =>  
            "<h3>@title</h3>  
            <img src="@url" alt="@alt" title="@alt">  
            <p>@alt</p>"  
        }
    MD

    def default_options
      {
        :expected_receive_period_in_days => "2",
        :template => "<h3>@title</h3><br\>\n" +
          "<img src=\"@url\" alt=\"@alt\" title=\"@alt\"><br\>\n" +
          "<p>@alt</p>",
      }
    end

    def receive(incoming_events)
      incoming_events.each do |event|
        # Substitute all available inputs into the template
        message = options[:template].gsub(/@\w+/) do |match|
          event[:payload][match[1..-1].to_sym]
        end

        create_event :payload => { :message => message }
      end
    end

    def working?
      last_receive_at && last_receive_at > options[:expected_receive_period_in_days].to_i.days.ago
    end
  end
end
