class CreateRepoFiles < ActiveRecord::Migration
  def change
    create_table :repo_files do |t|
      t.references :repository
      t.string :file

      t.timestamps
    end
    add_index :repo_files, :repository_id
  end
end
