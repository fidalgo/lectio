require 'zip'
require 'set'
require 'httparty'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.where(email: 'admin@example.com').first.destroy
user = User.create email: 'admin@example.com', password: 'password', password_confirmation: 'password', name: 'Admin'

list_url = 'http://s3.amazonaws.com/alexa-static/top-1m.csv.zip'

file = Tempfile.new('top-1m.csv.zip')
file.binmode
begin
  file.write HTTParty.get(list_url).parsed_response
  links = []
  Zip::InputStream.open(file) do |input_stream|
    input_stream.get_next_entry
    input_stream.each do |line|
      links << [user.id, line.strip.split(',').last]
    end
  end
ensure
  file.close
  file.unlink
end
columns = [:user_id, :url]

Link.import columns, links, validate: false
