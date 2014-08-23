require 'mongrel'
require './lib/httparty'
require 'spec/expectations'

Before do
  temp_options_file = File.dirname(__FILE__) + '/../../.httpartyrc'
  temp_options_dir = File.dirname(temp_options_file)
  Dir.mkdir(temp_options_dir) unless Dir.exists?(temp_options_dir)
  File.delete(temp_options_file) if File.exists?(temp_options_file)

  def new_port
    server = TCPServer.new('0.0.0.0', nil)
    port = server.addr[1]
  ensure
    server.close
  end

  port = ENV["HTTPARTY_PORT"] || new_port
  @host_and_port = "0.0.0.0:#{port}"
  @server = Mongrel::HttpServer.new("0.0.0.0", port)
  @server.run
  @request_options = {}
end

After do
  temp_options_file = File.dirname(__FILE__) + '/../../.httpartyrc'
  File.delete(temp_options_file) if File.exists?(temp_options_file)

  @server.stop
end
