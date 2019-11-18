class TimeFormatter

  attr_reader :result

  CORRECT_FORMATS = {'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def initialize(formats, time = nil)
    @formats = formats
    @time = time || Time.now
    @success = false  
  end

  def call
    parse_result = parse_time

    @success = parse_result[:unknown_formats].empty?

    unless @success
      @result = "Unknown time format #{parse_result[:unknown_formats].to_s}"
      @result.gsub!("\"", "")
      return  
    end

    @result = @time.strftime(parse_result[:time_params])
  end

  def success?
    @success
  end

  private

  def parse_time
    result = { time_params: "", unknown_formats: [] }

    @formats.each { |format|
      if CORRECT_FORMATS.include?(format)
        result[:time_params] << "-" unless result[:time_params].empty?
        result[:time_params] << CORRECT_FORMATS[format]
      else
        result[:unknown_formats] << format
      end
    }

    result
  end

end
