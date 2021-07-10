require 'fileutils'
require 'base64'

require_relative 'lib'
require_relative 'classes/logger'
require_relative 'classes/inmate'

directory = 'inmates'
FileUtils.rm_rf(directory) if File.exists?(directory)
Dir.mkdir(directory)

directory = 'mugshots'
FileUtils.rm_rf(directory) if File.exists?(directory)
Dir.mkdir(directory)

logger = Logger.new('logs.txt')

output_filename = 'charges.csv'
delete_file(output_filename)

('a'..'z').to_a.each do |letter|
  logger.log(letter.upcase)

  get_json("https://netapps.ocfl.net/BestJail/Home/getInmates/#{letter}").each do |record|
    if record['inmateName'] != 'PRESENTENCED'
      logger.log("#{record['bookingNumber']}\t#{record['inmateName']}")

      get_json("https://netapps.ocfl.net/BestJail/Home/getInmateDetails/#{record['bookingNumber']}").each do |details|
        inmate = Inmate.new(details['BOOKING'], details['NAME'], details['GENDER'], details['RACE'], details['BIRTH'])

        File.open("mugshots/#{inmate.booking}.png", 'wb') do |f|
          f.write(Base64.decode64(details['IMAGE']))
        end

        get_json("https://netapps.ocfl.net/BestJail/Home/getCharges/#{inmate.booking}").each do |charge|
          inmate.add_charge(charge['Charge'])
          file_write(output_filename, "#{inmate.booking}\t#{inmate.name}\t#{charge['Charge']}")
        end

        inmate.save
      end
    end
  end
end
