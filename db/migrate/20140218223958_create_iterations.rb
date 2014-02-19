class CreateIterations < ActiveRecord::Migration
  def change
    create_table :iterations do |t|
      t.integer :project_id
      t.datetime :start_date
      t.datetime :end_date
      t.string :title
      t.text :theme
    end
  end
end
