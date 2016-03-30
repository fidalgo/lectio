require 'zip'
require 'set'
require 'httparty'

namespace :data do
  desc "Add URL's from Alexa list"
  task :links, [:limit] => :environment do |_t, args|
    limit = args.limit ? args.limit.to_i : 1_000_000
    user = User.find_by_email('admin@example.com')
    Link.where(user: user).delete_all
    Tagging.where(tagger: user).delete_all
    user.destroy
    user = User.create email: 'admin@example.com', password: 'password', password_confirmation: 'password', name: 'Admin'

    list_url = 'http://s3.amazonaws.com/alexa-static/top-1m.csv.zip'

    file = Tempfile.new('top-1m.csv.zip')
    file.binmode
    file.write HTTParty.get(list_url).parsed_response
    links = []
    Zip::InputStream.open(file) do |input_stream|
      input_stream.get_next_entry
      input_stream.each do |line|
        break if links.size > limit
        links << [user.id, line.strip.split(',').last]
      end
    end
    columns = [:user_id, :url]
    Link.import columns, links, validate: false
    Link.where(user: user).pluck(:id).each { |id| UrlScrapperJob.perform_later id }
  end
end
