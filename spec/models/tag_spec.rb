require 'rails_helper'

RSpec.describe Tag, type: :model do
  context 'indexes' do
    it { should have_db_index(:name).unique }
  end

  context 'columns' do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
  end

  context 'attributes' do
    it 'has name' do
      name = Faker::Hipster.word
      expect(build(:tag, name: name)).to have_attributes(name: name)
    end
  end

  context 'validation' do
    it 'requires name' do
      expect(build(:tag)).to validate_presence_of(:name)
    end
    it 'requires unique name' do
      expect(build(:tag)).to validate_uniqueness_of(:name)
    end
  end
end
