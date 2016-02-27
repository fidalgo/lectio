require 'rails_helper'

RSpec.describe Tagging, type: :model do
  context 'db' do
    context 'indexes' do
      it { should have_db_index(:tag_id) }
      it { should have_db_index(%w(taggable_type taggable_id)) }
      it { should have_db_index(%w(tagger_type tagger_id)) }
    end

    context 'columns' do
      it { should have_db_column(:tag_id).of_type(:integer).with_options(null: false) }
      it { should have_db_column(:taggable_id).of_type(:integer).with_options(null: false) }
      it { should have_db_column(:taggable_type).of_type(:string).with_options(null: false) }
      it { should have_db_column(:tagger_id).of_type(:integer).with_options(null: false) }
      it { should have_db_column(:tagger_type).of_type(:string).with_options(null: false) }
    end
  end

  context 'attributes' do
    it 'has tag' do
      tag =  build(:tag)
      expect(build(:tagging, tag: tag)).to have_attributes(tag: tag)
    end

    it 'has taggable' do
      taggable = build(:link)
      expect(build(:tagging, taggable: taggable)).to have_attributes(taggable_id: taggable.id, taggable_type: taggable.class.to_s)
    end

    it 'has tagger' do
      tagger = build(:user)
      expect(build(:tagging, tagger: tagger)).to have_attributes(tagger_id: tagger.id, tagger_type: tagger.class.to_s)
    end
  end

  context 'validation' do
    let(:tagging) { build(:tagging) }

    it 'requires tag' do
      expect(tagging.tag).not_to be_nil
    end
    it 'requires taggable' do
      expect(tagging.taggable).not_to be_nil
    end
    it 'requires tagger' do
      expect(tagging.tagger).not_to be_nil
    end
  end
end
