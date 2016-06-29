class CreateUserEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :user_events do |t|
      t.references :user, foreign_key: true
      t.references :event, foreign_key: true
      t.integer :status
      t.integer :user_role

      t.timestamps
    end
    add_index :user_events, [:user_id , :event_id] , :unique => true
  end
end
