require 'time'

require_relative '../lib'

class Logger
  def initialize(filename)
    @filename = filename
    delete_file(@filename)
    log(Time.now.to_s)
  end

  def log(text)
    puts(text)
    file_write(@filename, text)
  end
end
