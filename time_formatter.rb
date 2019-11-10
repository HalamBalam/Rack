class TimeFormatter

  CORRECT_FORMATS = %w[year month day hour minute second]

  def self.format_time(formats, time = nil)
    time ||= Time.now

    result = ""
    unknown_formats = []

    formats.each { |format|
      if CORRECT_FORMATS.include?(format)
        result << "-" unless result.empty?

        if format == "minute"
          result << time.min.to_s
        elsif format == "second"
          result << time.sec.to_s
        else
          result << time.send(format.to_sym).to_s
        end
      else
        unknown_formats << format
      end
    }

    unless unknown_formats.empty?
      error = "Unknown time format #{unknown_formats.to_s}"
      error.gsub!("\"", "")

      raise error  
    end

    result
  end

end
