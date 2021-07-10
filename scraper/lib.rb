require 'open-uri'
require 'net/http'
require 'json'

def get_json(url)
  sleep(0.25)
  uri = URI.parse(url)
  response = Net::HTTP.get_response(uri)
  JSON.parse(response.body)
end

def delete_file(filename)
  File.delete(filename) if File.file?(filename)
end

def file_write(filename, text)
  open(filename, 'a') { |f| f.puts(text) }
end