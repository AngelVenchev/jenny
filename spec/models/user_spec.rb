require 'spec_helper'
require 'digest/sha3'

describe User do
  include Rack::Test::Methods

  def app
    App.new
  end

  before do
    ActiveRecord::Base.establish_connection(
      adapter: 'sqlite3',
      database: './test.db')
  end

  describe 'validation' do
    let(:credentials1) do
      {
        username: 'test_user',
        email: 'test_email',
        password: 'test_password'
      }
    end
    let(:credentials2) do
      {
        username: 'TEST_user',
        email: 'test_email',
        password: 'test_password'
      }
    end
    let(:credentials3) do
      {
        username: 'test_user2',
        email: 'test_email',
        password: 'test_password'
      }
    end
    let(:credentials4) do
      {
        username: 'test_user3',
        email: 'test_EMAIL',
        password: 'test_password'
      }
    end
    before do
      user = User.init(credentials1)
      user.save
    end

    it "doesn't allow users without a username" do
      mail_password =
      {
        email: 'mail@mail.com',
        password: 'pass'
      }
      User.create(mail_password).errors.size.should_not == 0
    end

    it "doesn't allow users without an email" do
      username_password =
      {
        username: 'username',
        password: 'pass'
      }
      User.create(username_password).errors.size.should_not == 0
    end

    it "doesn't allow user without a password" do
      username_mail =
      {
        username: 'username',
        email: 'mail@mail.com'
      }
      User.create(username_mail).errors.size.should_not == 0
    end

    it "doesn't allow username duplication" do
      user = User.init(credentials1)
      user.save.should == false
    end

    it "doesn't alllow different case username duplication" do
      user = User.init(credentials2)
      user.save.should == false
    end

    it "doesn't allow email duplication" do
      user = User.init(credentials3)
      user.save.should == false
    end

    it 'allows different case email duplication' do
      user = User.init(credentials4)
      user.save.should == true
    end

    after do
      User.delete_all
    end
  end

  describe 'password digest' do
    let(:credentials1) do
      {
        username: 'test1',
        email: 'test1',
        password: 'test'
      }
    end
    let(:credentials2) do
      {
        username: 'test2',
        email: 'test2',
        password: 'test'
      }
    end

    it 'is 128bit' do
      user = User.init(credentials1)
      user.save
      user.password.size.should == 128
    end

    it 'is not plain text' do
      user1 = User.init(credentials1)
      user2 = User.new(credentials2)
      user1.password.should_not == user2.password
    end

    it 'is a sha3 hexdigest from user password' do
      user = User.init(credentials1)
      digested_password = Digest::SHA3.hexdigest(credentials1[:password])
      user.password.should == digested_password
    end
    after do
      User.delete_all
    end
  end

  describe 'authentication' do
    let(:register_credentials) do
      {
        username: 'user',
        email: 'mail',
        password: 'pass'
      }
    end
    let(:login_credentials) { %w(user pass) }

    context 'non-existing user' do
      it 'can create user' do
        user = User.init(register_credentials)
        user.save
      end

      after do
        User.delete_all
      end
    end

    context 'existing user' do
      before do
        user = User.init(register_credentials)
        user.save
      end

      it 'can authenticate user' do
        user = User.authenticate(*login_credentials)
        user.should_not.nil?
      end

      after do
        User.delete_all
      end
    end
  end
end
