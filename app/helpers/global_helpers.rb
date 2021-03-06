module Merb
  module GlobalHelpers
    # helpers defined here available to all views.
    
    def output_value(kind, value)
  		case kind.to_s
  		when 'image'
  			'<a href="'+value+'" title="'+value+'"><img src="'+value+'" alt="'+value+'" title="'+value+'" /></a>'
  		when 'text', 'caption'
  			value.to_s
  		end
		#"<em>(empty value; error!)</em>" if value.nil? or value.empty?
  	end
  
  
    def number_with_precision(number, precision=3)
      "%01.#{precision}f" % number
    rescue
      number
    end
  	  	
  	def sanitize(string)
      string.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
        '%' + $1.unpack('H2' * $1.size).join('%').upcase
      end.tr(' ', '-').downcase
    end
    
    def user_link(user, entry = nil)
      num = entry.game.users.index(user) if not entry.nil? and entry.class == Entry
      num = entry if not entry.nil? and entry.class == Fixnum
      num ||= 0
      link_to user.username, url(:user, user), :class => "user-#{num} #{user.username}"
    end
    
    
    # options
    # :start_date, sets the time to measure against, defaults to now
    # :date_format, used with <tt>to_formatted_s<tt>, default to :default
    def timeago(time, options = {})
      start_date = options.delete(:start_date) || Time.new
      date_format = options.delete(:date_format) || :default
      delta_minutes = (start_date.to_i - time.to_i).floor / 60
      if delta_minutes.abs <= (8724*60) # eight weeks… I’m lazy to count days for longer than that
        distance = distance_of_time_in_words(delta_minutes);
        if delta_minutes < 0
          "#{distance} from now"
        else
          "#{distance} ago"
        end
      else
        return "on #{system_date.to_formatted_s(date_format)}"
      end
    end

    def distance_of_time_in_words(minutes)
      case
        when minutes < 1
          "less than a minute"
        when minutes < 50
          pluralize(minutes, "minute")
        when minutes < 90
          "about one hour"
        when minutes < 1080
          "#{(minutes / 60).round} hours"
        when minutes < 1440
          "one day"
        when minutes < 2880
          "about one day"
        else
          "#{(minutes / 1440).round} days"
      end
    end
    
    # Attempts to pluralize the +singular+ word unless +count+ is 1. See source for pluralization rules.
    def pluralize(count, singular, plural = nil)
       "#{count} " + if count == 1
        singular
      elsif plural
        plural
      elsif Object.const_defined?("Inflector")
        Inflector.pluralize(singular)
      else
        singular + "s"
      end
    end
    
    
  end
end    
