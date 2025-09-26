class AddPlagiarismStatusToDocuments < ActiveRecord::Migration[7.1]
  def change
    add_column :documents, :plagiarism_status, :string
  end
end
