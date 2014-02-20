require 'spec_helper'

describe ProjectController, :type => :controller do
  include Rack::Test::Methods

  def app
    App.new
  end

  before do
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: './test.db'
  end

  let(:params) do
     params =
      {
        username: "user",
        email: "mail@mail.com",
        password: 'pass'
      }
  end

  describe 'the project creation process' do
    before do
      user = User.init params
      bool = user.save
    end

    context 'logged in' do
      let(:logged_user) { User.find_by username: 'user' }

      before do
        post '/auth/login', params
        follow_redirect!
      end

      it 'shows create a new project form' do
        last_response.body.include?("href='/projects/new'").should == true
      end

      it 'shows project option' do
        get '/projects/new'
        last_response.body.include?("id='new_project_form'")
      end

      it 'allows me to crete project' do
        param = {name: 'test_project'}
        post '/projects', param

        project = Project.find_by name: 'test_project'
        project.should_not == nil
        logged_user.projects.first.should == project
      end
    end

    context 'not logged in' do
      before do
        get '/'
      end

      it "doesn't allow me to create a project" do
        last_response.body.include?("href='/projects/new'").should_not == true
      end

      it "doesn't allow me to create a project" do
        param = {name: 'test_project'}
        post '/projects', param

        project = Project.find_by name: 'test_project'
        project.should == nil
      end

      after do
        project = Project.find_by name: 'test_project'
        project.destroy if project
      end
    end

    after do
      user = User.find_by username: 'user'
      user.destroy if user
      project = Project.find_by name: 'test_project'
      project.destroy if project
    end
  end
end
