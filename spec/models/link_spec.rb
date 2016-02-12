require 'rails_helper'

RSpec.describe Link, type: :model do
  it_behaves_like 'taggable'
  context 'db' do
    context 'indexes' do
      it { should have_db_index(:user_id) }
    end

    context 'columns' do
      it { should have_db_column(:url).of_type(:string).with_options(null: false) }
      it { should have_db_column(:title).of_type(:string) }
      it { should have_db_column(:user_id).of_type(:integer).with_options(null: false) }
      it { should have_db_column(:read).of_type(:boolean).with_options(default: false, null: false) }
      it { should have_db_column(:description).of_type(:string) }
    end
  end

  context 'attributes' do
    it 'has url' do
      url = Faker::Internet.url
      expect(build(:link, url: url)).to have_attributes(url: url)
    end

    it 'has title' do
      title = Faker::Hipster.sentence
      expect(build(:link, title: title)).to have_attributes(title: title)
    end

    it 'has description' do
      description = Faker::Hipster.sentence
      expect(build(:link, description: description)).to have_attributes(description: description)
    end

    it 'has read' do
      read = false
      expect(build(:link, read: read)).to have_attributes(read: read)
    end

    it 'has user' do
      user = build(:user)
      expect(build(:link, user: user)).to have_attributes(user: user)
    end
  end

  context 'validation' do
    let(:link) { build(:link) }

    it 'requires url' do
      expect(link).to validate_presence_of(:url)
    end
    it 'requires user' do
      expect(link).to validate_presence_of(:user)
    end
    it 'requires read' do
      expect([true, false]).to include(link.read)
    end
  end

  describe '#status' do
    it 'should be readed' do
      read = build(:link, read: true)
      expect(read.status).to eq 'readed'
    end
    it 'should be unreaded' do
      unread = build(:link, read: false)
      expect(unread.status).to eq 'unreaded'
    end
  end

  describe '#add_scheme_to_url' do
  end
end
