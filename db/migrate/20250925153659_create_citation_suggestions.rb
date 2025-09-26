class CreateCitationSuggestions < ActiveRecord::Migration[7.1]
  def change
    create_table :citation_suggestions do |t|
      t.references :document, null: false, foreign_key: true
      t.text :original_text
      t.text :suggested_citation
      t.string :source_url
      t.string :status

      t.timestamps
    end
  end
end
