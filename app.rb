require_relative 'time_formatter'
require 'rack'

class App

  PAGE_NOT_FOUND_ERROR = "Page not found"
  FORMAT_NOT_FOUND_ERROR = "[format] parameter not specified"

  def call(env)
    response = check_request(env)
    response = time_response(env) if response.nil?

    [response[:status], headers, response[:body]]
  end

  private

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def check_request(env)
    return send_response(PAGE_NOT_FOUND_ERROR, 404) if env['REQUEST_PATH'] != "/time"
    return send_response(FORMAT_NOT_FOUND_ERROR, 400) unless env['QUERY_STRING'].include?("format=")
  end

  def time_response(env)
    formats = time_formats(env)

    time_formatter = TimeFormatter.new(formats)
    time_formatter.call

    return send_response(time_formatter.result, 400) unless time_formatter.success?

    send_response(time_formatter.result, 200)
  end

  def time_formats(env)
    query_string = env['QUERY_STRING']

    query_string.gsub!("format=", "")
    query_string.gsub!("%2C", "\n")
    query_string.lines(chomp: true)
  end

  def send_response(body, status)
    { status: status, body: [body + "\n"] }
  end

end
