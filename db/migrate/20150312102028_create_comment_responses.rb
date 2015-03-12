class CreateCommentResponses < ActiveRecord::Migration
  def change
    create_table :comment_responses do |t|
      t.references :comment, index: true
      t.references :comment, index: true

      t.timestamps
    end
  end
end
