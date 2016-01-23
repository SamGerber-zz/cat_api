require 'socket'
require 'thread'
require 'json'

Thread.abort_on_exception = true

$id = 0
$cats = []

server = TCPServer.new(3000)

def handle_request(socket)
  Thread.new do
    cmd = socket.gets.chomp

    case cmd
    when "INDEX"
      socket.puts $cats.to_json
    when "SHOW"
      cat_id = Integer(socket.gets.chomp)
      cat = $cats.find { |cat| cat[:id] == cat_id }
      socket.puts(cat.to_json)
    when "CREATE"
      name = socket.gets.chomp
      cat_id = $id
      $id += 1
      $cats << { id: cat_id, name: name }
    when "UPDATE"
      cat_id = Integer(socket.gets.chomp)
      cat = $cats.find { |cat| cat[:id] == cat_id }

      new_name = socket.gets.chomp
      cat[:name] = new_name
    when "DESTROY"
      cat_id = Integer(socket.gets.chomp)
      $cats.reject! { |cat| cat[:id] == cat_id }
    end
    socket.close
  end
  puts "Spawned worker thread"
end

loop do
  socket = server.accept
  handle_request(socket)
end
