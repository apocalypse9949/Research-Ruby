class Document < ApplicationRecord
  has_one_attached :file
  attribute :embeddings, :vector

  validates :file, presence: true, content_type: ['application/pdf', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'text/plain'], size: { less_than: 20.megabytes }

  enum status: {
    processing: 'processing',
    completed: 'completed',
    failed: 'failed'
  }

  enum plagiarism_status: {
    not_checked: 'not_checked',
    checking: 'checking',
    plagiarized: 'plagiarized',
    unique: 'unique'
  }
end
