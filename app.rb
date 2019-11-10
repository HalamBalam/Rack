require_relative 'time_formatter'

class App

  PAGE_NOT_FOUND_RESPONSE = {
    status: 404,
    body: ["Page not found\n"]
  }

  FORMAT_NOT_FOUND_RESPONSE = {
    status: 400,
    body: ["[format] parameter not specified\n"]
  }

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

    begin
      time_str = TimeFormatter.format_time(query_string.lines(chomp: true))  
    rescue RuntimeError => error
      return { status: 400, body: [error.message + "\n"] }  
    end

    { status: 200, body: [time_str << "\n"] } 
  end

end
