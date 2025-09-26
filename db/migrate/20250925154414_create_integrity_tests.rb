class CreateIntegrityTests < ActiveRecord::Migration[7.1]
  def change
    create_table :integrity_tests do |t|
      t.references :document, null: false, foreign_key: true
      t.string :fact_check_status
      t.float :credibility_score
      t.text :suggestions

      t.timestamps
    end
  end
end
