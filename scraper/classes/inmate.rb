require_relative '../lib'

class Inmate
  attr_accessor :booking
  attr_accessor :name
  attr_accessor :gender
  attr_accessor :race
  attr_accessor :age
  attr_accessor :charges

  def initialize(booking, name, gender, race, age)
    @booking = booking
    @name = name
    @gender = gender
    @race = race
    @age = age

    @charges = []
  end

  def add_charge(charge)
    @charges.push(charge)
  end

  def to_hash
    {
      'booking' => @booking,
      'name' => @name,
      'gender' => @gender,
      'race' => @race,
      'age' => @age,
      'charges' => @charges
    }
  end

  def save
    file_write("output/inmates/#{@booking}.json", to_hash.to_json)
  end
end