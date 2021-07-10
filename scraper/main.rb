require 'open-uri'
require 'net/http'
require 'json'

require_relative 'lib'
require_relative 'logger'

logger = Logger.new('logs.txt')

output_filename = 'output.csv'
delete_file(output_filename)

('a'..'z').to_a.each do |letter|
  logger.log(letter)
  inmates = get_json("https://netapps.ocfl.net/BestJail/Home/getInmates/#{letter}")
  inmates.each do |inmate|
    booking_number = inmate['bookingNumber']
    inmate_name = inmate['inmateName']

    logger.log("#{booking_number}\t#{inmate_name}")

    get_json("https://netapps.ocfl.net/BestJail/Home/getCharges/#{booking_number}").each do |charge|
      file_write(output_filename, "#{booking_number}\t#{inmate_name}\t#{charge['Charge']}")
    end
  end
end
