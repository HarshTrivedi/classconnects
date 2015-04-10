class CreateCommentResponses < ActiveRecord::Migration
  def change
    create_table :comment_responses do |t|
      t.references :user, index: true
      t.references :comment, index: true
      t.string :message, default: "", null: false
      t.timestamps
    end
  end
end
