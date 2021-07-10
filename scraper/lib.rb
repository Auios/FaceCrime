require 'open-uri'
require 'net/http'
require 'json'

def get_json(url)
  #sleep(0.25)
  begin
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    result = JSON.parse(response.body)
  rescue
    puts "MISSING\t#{url}"
    result = []
  end

  result
end

def delete_file(filename)
  File.delete(filename) if File.file?(filename)
end

def file_write(filename, text)
  open(filename, 'a') { |f| f.puts(text) }
end