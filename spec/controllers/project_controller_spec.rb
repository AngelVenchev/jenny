require 'spec_helper'

describe ProjectController, :type => :controller do
  include Rack::Test::Methods

  def app
    App.new
  end

  before do
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: './test.db'
  end

  let(:params) { {username: "user", email: "mail@mail.com", password: 'pass'} }
  let(:params2) { {username: "user2", email: "mail2@mail.com", password: 'pass'} }

  describe 'the project creation process' do
    before do
      user = User.init params
      user.save
    end

    context 'when logged in' do
      let(:logged_user) { User.find_by username: 'user' }

      before do
        post '/auth/login', params
      end

      it 'shows create a new project option' do
        follow_redirect!
        last_response.body.include?("href='/projects/new'").should == true
      end

      it 'shows create a new project form' do
        get '/projects/new'
        last_response.body.include?("id='new_project_form'")
      end

      it 'allows me to create project' do
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

  describe 'project viewing' do

    let(:project_params1) { {name: 'test_project_no_description'} }
    let(:project_params2) { {name: 'test_project', description: 'test_description'} }

    let(:iteration_params) do
      {project_id: 1, start_date: DateTime.now, end_date: DateTime.now, title: "test_iteration"}
    end

    before do
      user = User.init params
      user.save

      user2 = User.init params2
      user2.save

      regular_project = Project.create(project_params1)
      common_project = Project.create(project_params2)

      user.projects << regular_project
      user.projects << common_project

      user2.projects << common_project
    end

    context 'when logged in' do
      let(:logged_user) { User.find_by username: params[:username] }

      before do
        post '/auth/login', params
        follow_redirect!
      end

      it 'shows user projects' do
        last_response.body.include?(project_params1[:name]).should == true
        last_response.body.include?(project_params2[:name]).should == true
      end

      it 'shows project detailed information' do
        project = Project.find_by(name: project_params2[:name])
        get "/projects/#{project.id}/edit"
        last_response.body.include?(project_params2[:name]).should == true
        last_response.body.include?(project_params2[:description]).should == true
      end

      it 'shows users working on the current project' do
        project = Project.find_by(name: project_params2[:name])
        get "/projects/#{project.id}/edit"
        last_response.body.include?(params[:username]).should == true
        last_response.body.include?(params2[:username]).should == true
      end

      it 'shows iteration explorer' do
        project = Project.find_by(name: project_params2[:name])
        get "/projects/#{project.id}"
        last_response.body.include?(iteration_params[:title])
      end
    end

    context 'when not logged in' do

      before do
        get '/'
      end

      it "doesn't show user projects" do
        last_response.body.include?(project_params1[:name]).should_not == true
        last_response.body.include?(project_params2[:name]).should_not == true
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
      Iteration.delete_all
    end
  end
end
