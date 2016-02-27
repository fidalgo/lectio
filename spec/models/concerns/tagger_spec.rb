shared_examples_for 'tagger' do
  let(:model) { create(described_class.to_s.underscore) }

  it 'has many taggings' do
    expect(model).to have_many(:taggings).dependent(:destroy)
  end

  it 'has many tags' do
    expect(model).to have_many(:tags).through(:taggings).source(:tag)
  end

  context '#tag' do
    it 'adds tags' do
      link = create(:link)
      tags = %w(Ruby Rails)
      model.tag(link, tags)
      expect(link.tags_list).to match_array(tags)
    end

    it 'removes the duplicates' do
      link = create(:link)
      tags = %w(Ruby Rails Ruby)
      model.tag(link, tags)
      expect(link.tags_list.size).to eq(2)
    end

    it 'removes tags' do
      link = create(:link)
      tags = %w(Ruby Rails)
      model.tag(link, tags)
      expect(link.tags_list.size).to eq(2)
      model.tag(link, tags.take(1))
      expect(link.tags_list.size).to eq(1)
    end

    it 'updates the tags' do
      link = create(:link)
      tags = %w(Ruby Rails)
      model.tag(link, tags)
      expect(link.tags_list).to match_array(tags)
      new_tags = %w(Matz Linus)
      model.tag(link, new_tags)
      expect(link.tags_list).to match_array(new_tags)
    end
  end
end
