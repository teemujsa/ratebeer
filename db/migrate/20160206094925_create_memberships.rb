class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :beer_club_id
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :memberships, :beer_club_id
    add_index :memberships, :user_id
  end
end
