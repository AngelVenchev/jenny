class CreateUserStories < ActiveRecord::Migration
  def change
    create_table :user_stories do |t|
      t.integer :project_id
      t.integer :iteration_id
      t.string :title
      t.text :description
      t.integer :status, default: 0
      t.boolean :ready, default: false
      t.boolean :blocked, default: false
      t.string :blocked_reason
      t.float :task_estimate, default: 0
      t.float :actual, default: 0
      t.float :to_do, default: 0
      t.timestamps
    end
  end
end
