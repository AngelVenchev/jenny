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
      user.save
    end

    context 'when logged in' do
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

      after do
        get 'auth/logout'
      end
    end

    context 'when not logged in' do
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
      User.delete_all
      Project.delete_all
    end
  end

  describe 'project viewing process' do

    let(:project_params1) { {name: 'test'} }
    let(:project_params2) { {name: 'test2', description: 'test_descr'} }

    before do
      user = User.init params
      user.save
      user.projects << Project.create(project_params1)
      user.projects << Project.create(project_params2)
    end

    context 'when logged in' do
      let(:logged_user) { User.find_by params[:username] }

      before do
        post '/auth/login', params
        follow_redirect!
      end

      it 'shows user projects' do
        last_response.body.include?("test").should == true
        last_response.body.include?("test2").should == true
      end

      it 'shows project detailed information' do
        project = Project.find_by(name: project_params2[:name])
        get "/projects/#{project.id}"
        last_response.body.include?(project_params2[:name]).should == true
        last_response.body.include?(project_params2[:description]).should == true
      end
    end

    context 'when not logged in' do

      before do
        get '/'
      end

      it "doesn't show user projects" do
        last_response.body.include?("test").should_not == true
        last_response.body.include?("test2").should_not == true
      end

      it "doesn't show project detailed information" do
        project = Project.find_by(name: project_params2[:name])
        get "/projects/#{project.id}"
        last_response.body.include?(project_params2[:name]).should_not == true
        last_response.body.include?(project_params2[:description]).should_not == true
      end
    end

    after do
      User.delete_all
      Project.delete_all
    end
  end
end
