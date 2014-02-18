require 'spec_helper'

describe Project do
  include Rack::Test::Methods

  def app
    App.new
  end

  before do
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: './test.db'
  end

  describe "validation" do

    before do
      Project.create(name:"test_project")
    end

    it "doesn't allow nameless projects" do
      Project.create.errors.any?.should == true
    end

    it "doesn't allow name duplication" do
      Project.create(name:"test_project").errors.any?.should == true
    end

    it "doesn't allow diffrent case name duplication" do
      Project.create(name:"test_PROJECT").errors.any?.should == true
    end

    after do
      Project.delete_all
    end
  end

  describe "association" do
    before do
      Project.create(name:'project1')
      Project.create(name:'project2')
      User.create(username:'user1',email:'mail1', password:'pass')
      User.create(username:'user2',email:'mail2', password:'pass')
    end

    let(:proj1) { Project.find_by name:'project1' }
    let(:proj2) { Project.find_by name:'project2' }
    let(:user1) { User.find_by username:'user1' }
    let(:user2) { User.find_by username:'user2' }

    it 'has many users' do
      proj1.users << user1
      proj1.users << user2
      project_id = proj1.id
      modified_project = Project.find project_id
      modified_project.users.size.should == 2
    end

    it 'has and belongs to many users' do
      user1.projects << proj1
      user1.projects << proj2
      user2.projects << proj1

      user2.projects.first.users.size.should == 2
    end

    after do
      Project.delete_all
    end
  end
end