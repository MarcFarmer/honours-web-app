class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.references :pathway

      t.timestamps
    end
    add_index :tags, :pathway_id
  end
end
