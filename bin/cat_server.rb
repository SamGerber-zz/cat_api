require 'socket'
require 'thread'
require 'json'

# TCP (Transmission Control Protocol) to transfer data back and forth
# from client and sever. This work is usually done for us.
# Bespoke protocol. Replace with HTTP (HyperText Transfer Protocol).
# HTML (HyperText Markup Language).
# HyperText is just text with links.

# TCP Information:
# We would send, to www.google.com port 80:
# www.google.com is the domain name
# 80 is the port

# HTTP part (data sent over TCP)
# GET / HTTP/1.1
# Host: www.google.com

# METHOD PATH PROTOCOL_VERSION
# HEADER_NAME: HEADER_VALUE

# * GET - retrieve some data
# * POST - save some data
# * DELETE - delete some data
# * PATCH - update some data

Thread.abort_on_exception = true

$id = 2
$cats = [
  {"id" => 1, "name" => "Markov"},
  {"id" => 2, "name" => "Curie"}
]

server = TCPServer.new(3000)

def handle_request(socket)
  Thread.new do
    # METHOD PATH PROTOCOL_VERSION
    line1 = socket.gets.chomp

    re = /([^ ]+) ([^ ]+) HTTP\/1.1$/
    raise unless match_data = re.match(line1)
    verb = match_data[1]
    path = match_data[2]

    cat_regex = /\/cats\/(\d+)/
    if [verb, path] == ["GET", "/cats"]
      # GET /cats
      socket.gets # reads a blank line
      socket.puts $cats.to_json
    elsif verb == "GET" && match_data2 = cat_regex.match(path)
      # GET /cats/:id
      socket.gets # reads a blank line
      cat_id = Integer(match_data2[1])
      cat = $cats.find { |cat| cat["id"] == cat_id }
      socket.puts(cat.to_json)
    elsif verb == "DELETE" && match_data2 = cat_regex.match(path)
      # DELETE /cats/:id
      socket.gets # reads a blank line
      cat_id = Integer(match_data2[1])
      $cats.reject! { |cat| cat["id"] == cat_id }
      socket.puts(true.to_json)
    elsif [verb, path] == ["POST", "/cats"]
      header1 = socket.gets.chomp
      match_data2 = /Content-Length: (\d+)/.match(header1)
      content_length = Integer(match_data2[1])
      socket.gets # reads a blank line

      body_data = socket.gets.chomp
      cat = JSON.parse(body_data)
      cat["id"] = ($id += 1)
      $cats << cat


      socket.puts(cat.to_json)
    elsif verb == "PATCH" && match_data2 = cat_regex.match(path)
      header1 = socket.gets.chomp
      match_data3 = /Content-Length: (\d+)/.match(header1)
      content_length = Integer(match_data3[1])
      socket.gets # reads a blank line

      body_data = socket.gets.chomp
      cat_id = Integer(match_data2[1])

      cat = $cats.find { |cat| cat["id"] == cat_id }
      JSON.parse(body_data).each do |(key, value)|
        cat[key] = value
      end

      socket.puts cat.to_json
    end
    socket.close
  end
  puts "Spawned worker thread"
end

loop do
  socket = server.accept
  handle_request(socket)
end
