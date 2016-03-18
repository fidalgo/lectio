require 'rails_helper'

RSpec.describe User, type: :model do
  it_behaves_like 'tagger'
  context 'db' do
    context 'indexes' do
      it { should have_db_index(:email) } # .with_options(unique: true) }
      it { should have_db_index(:reset_password_token) } # .with_options(unique: true) }
    end

    context 'columns' do
      it { should have_db_column(:name).of_type(:string).with_options(null: false) }
      it { should have_db_column(:email).of_type(:string).with_options(null: false) }
      it { should have_db_column(:encrypted_password).of_type(:string) }
      it { should have_db_column(:reset_password_token).of_type(:string) }
      it { should have_db_column(:reset_password_sent_at).of_type(:datetime) }
      it { should have_db_column(:remember_created_at).of_type(:datetime) }
      it { should have_db_column(:sign_in_count).of_type(:integer).with_options(default: 0, null: false) }
      it { should have_db_column(:current_sign_in_at).of_type(:datetime) }
      it { should have_db_column(:last_sign_in_at).of_type(:datetime) }
      it { should have_db_column(:current_sign_in_ip).of_type(:string) }
      it { should have_db_column(:last_sign_in_ip).of_type(:string) }
      it { should have_db_column(:role).of_type(:integer).with_options(default: User.roles['user'], null: false) }
    end

    context 'attributes' do
      it 'has name' do
        name = Faker::Name.name
        expect(build(:user, name: name)).to have_attributes(name: name)
      end

      it 'has email' do
        email = Faker::Internet.safe_email
        expect(build(:user, email: email)).to have_attributes(email: email)
      end

      it 'has password' do
        password = Faker::Internet.password
        expect(build(:user, password: password, password_confirmation: password)).to have_attributes(password: password)
      end
    end

    context 'validation' do
      it 'has many links' do
        expect(build(:user)).to have_many(:links).dependent(:destroy)
      end
    end
  end
end
