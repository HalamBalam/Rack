class App

  PAGE_NOT_FOUND_RESPONSE = {
    status: 404,
    body: ["Page not found\n"]
  }

  FORMAT_NOT_FOUND_RESPONSE = {
    status: 400,
    body: ["[format] parameter not specified"]
  }

  CORRECT_FORMATS = %w[year month day hour minute second]

  def call(env)
    response = response(env)

    [response[:status], headers, response[:body]]
  end

  private

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def response(env)
    return PAGE_NOT_FOUND_RESPONSE if env['REQUEST_PATH'] != "/time"
    
    query_string = env['QUERY_STRING']
    return FORMAT_NOT_FOUND_RESPONSE unless query_string.include?("format=")

    query_string.gsub!("format=", "")
    query_string.gsub!("%2C", "\n")

    unknown_formats = []
    time_str = ""

    current_time = Time.now

    formats = query_string.lines(chomp: true)
    formats.each { |format|
      if CORRECT_FORMATS.include?(format)
        time_str << "-" unless time_str.empty?

        if format == "minute"
          time_str << current_time.min.to_s
        elsif format == "second"
          time_str << current_time.sec.to_s
        else
          time_str << current_time.send(format.to_sym).to_s
        end
      else
        unknown_formats << format
      end
    }

    unless unknown_formats.empty?
      error = "Unknown time format #{unknown_formats.to_s}"
      error.gsub!("\"", "")

      return { status: 400, body: [error << "\n"] }  
    end

    { status: 200, body: [time_str << "\n"] } 
  end

end
