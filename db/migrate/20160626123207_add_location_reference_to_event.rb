class AddLocationReferenceToEvent < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :location, foreign_key: true
    add_column :events, :status, :integer, default: 0
  end
end
