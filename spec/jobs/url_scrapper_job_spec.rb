require 'rails_helper'

RSpec.describe UrlScrapperJob, type: :job do
  describe '#perform' do
    include ActiveJob::TestHelper
    it 'gets the title' do
      expect do
        link = create(:link, title: nil)
        link.update_title_and_description
        expect(link.title).to be nil
      end.to change { enqueued_jobs.size }.by 1
    end
  end
end
