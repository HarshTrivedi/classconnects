class CreateCollegeBranchPairs < ActiveRecord::Migration
  def change
    create_table :college_branch_pairs do |t|
      t.references :college, index: true
      t.references :branch, index: true

      t.timestamps
    end
  end
end
