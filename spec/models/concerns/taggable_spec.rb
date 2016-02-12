shared_examples_for 'taggable' do
  let(:model) { build(described_class.to_s.underscore) } # the class that includes the concern

  it 'has many taggings' do
    expect(model).to have_many(:taggings).dependent(:destroy)
  end

  it 'has many tags' do
    expect(model).to have_many(:tags).through(:taggings)
  end

  describe '#tags_list' do
    it 'lists the tag names' do
      ruby_tag = build(:tag, name: 'ruby')
      rails_tag = build(:tag, name: 'rails')
      user = build(:user)
      taggable = create(described_class.to_s.underscore)
      create(:tagging, tag: ruby_tag, taggable: taggable, tagger: user)
      create(:tagging, tag: rails_tag, taggable: taggable, tagger: user)
      expect(taggable.tags_list.size).to eq(2)
    end
  end
end
