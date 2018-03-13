require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) do
    FactoryBot.build(:user,
      username: "tlb@fakesite.com",
      password: "good_password")
  end

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:session_token) }
  it { should validate_length_of(:password).is_at_least(6) }

  it { should have_many(:goals) }
  it { should have_many(:comments) }

  it "creates a password digest" do
    expect(user.password_digest).to_not be(nil)
  end

  it "creates a session token before validation" do
    expect(user.session_token).to_not be(nil)
  end


  describe "#reset_session_token" do
    it "sets new session token" do
      user.valid?
      old_token = user.session_token
      user.reset_session_token

      expect(user.session_token).to_not eq(old_token)

    end

    it "returns the new session token" do
      expect(user.reset_session_token).to eq(user.session_token)
    end
  end

  describe "#is_password?" do
    it "verifies that a password is correct" do
      expect(user.is_password?("good_password")).to be true
    end

    it "verifies that a password is not correct" do
      expect(user.is_password?("bad_password")).to be false
    end
  end

  describe "User::find_by_credentials" do
    before{ user.save!}
    
    it "finds a user when given correct username and password" do
      expect(User.find_by_credentials('tlb@fakesite.com', 'good_password')).to eq(user)
    end

    it "returns nil if username and password is incorrect" do
      expect(User.find_by_credentials('tlb@fakesite.com', 'bad_password')).to eq(nil)
    end
  end

end
