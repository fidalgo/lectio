require 'rails_helper'

RSpec.describe UrlScrapperJob, type: :job do
  describe '#perform' do
    include ActiveJob::TestHelper
    it 'gets the title' do
      link = create(:link, title: nil)
      expect(link.title).to be nil
      expect(enqueued_jobs.size).to be 0
      UrlScrapperJob.perform_later link
      expect(enqueued_jobs.size).to be 1
    end
  end
end
