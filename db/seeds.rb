require 'zip'
require 'set'
require 'httparty'

if ENV['LECTIO_SEED']
  User.where(email: 'admin@example.com').destroy_all
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
else
  puts 'Set LECTIO_SEED environment variable to enable the seeding.'
end
