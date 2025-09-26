class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.string :status
      t.text :extracted_text

      t.timestamps
    end
  end
end
