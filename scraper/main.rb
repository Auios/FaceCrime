require 'fileutils'
require 'base64'

require_relative 'lib'
require_relative 'classes/logger'
require_relative 'classes/inmate'

output_directory = 'output'
FileUtils.rm_rf(output_directory) if File.exists?(output_directory)
Dir.mkdir(output_directory)
Dir.mkdir("#{output_directory}/inmates")
Dir.mkdir("#{output_directory}/mugshots")

logger = Logger.new("#{output_directory}/logs.txt")

output_filename = "#{output_directory}/charges.csv"
delete_file(output_filename)

('a'..'z').to_a.each do |letter|
  logger.log(letter.upcase)

  get_json("https://netapps.ocfl.net/BestJail/Home/getInmates/#{letter}").each do |record|
    if record['inmateName'] != 'PRESENTENCED'
      logger.log("#{record['bookingNumber']}\t#{record['inmateName']}")

      get_json("https://netapps.ocfl.net/BestJail/Home/getInmateDetails/#{record['bookingNumber']}").each do |details|
        inmate = Inmate.new(details['BOOKING'], details['NAME'], details['GENDER'], details['RACE'], details['BIRTH'])

        File.open("#{output_directory}/mugshots/#{inmate.booking}.png", 'wb') do |f|
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
