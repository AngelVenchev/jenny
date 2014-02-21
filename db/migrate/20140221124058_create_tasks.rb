class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :user_story_id
      t.integer :executor_id
      t.integer :tester_id
      t.string :title
      t.text :description
      t.integer :status, default: 0
      t.boolean :blocked, default: false
      t.string :blocked_reason
      t.float :task_estimate, default: 0
      t.float :actual, default: 0
      t.float :to_do, default: 0
      t.timestamps
    end
  end
end
