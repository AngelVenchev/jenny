require 'spec_helper'
require 'date'

describe Project do
  include Rack::Test::Methods

  def app
    App.new
  end

  before do
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: './test.db'
  end

  describe 'validation' do

    let(:project) { Project.create(name: 'name', description: 'description') }

    it "doesn't allow records with no title" do
      params =
      {
        project_id: project.id,
        start_date: DateTime.now,
        end_date: DateTime.now
      }
      Iteration.create(params).errors.size.should_not == 0
    end

    it "doesn't allow records with no end or start dates" do
      params1 = {project_id: project.id, title: 'test', start_date: DateTime.now}
      params2 = {project_id: project.id, title: 'test', end_date: DateTime.now}

      Iteration.create(params1).errors.size.should_not == 0
      Iteration.create(params2).errors.size.should_not == 0
    end

    after do
      Iteration.delete_all
      Project.delete_all
    end
  end

  describe 'association' do
    let(:project) { Project.create(name:'name', description: 'description') }

    it 'belongs to project' do
      params =
      {
        project_id: project.id,
        start_date: DateTime.now,
        end_date: DateTime.now,
        title: 'test'
      }
      iteration = Iteration.create(params)

      project.iterations.first.should == iteration
    end

    after do
      Iteration.delete_all
      Project.delete_all
    end
  end
end
