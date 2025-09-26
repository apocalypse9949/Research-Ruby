class PlagiarismCheckJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    document = Document.find(document_id)
    return unless document

    document.update!(plagiarism_status: :checking)

    begin
      # For simplicity, we'll compare against all other documents.
      # In a real application, you might want to limit this to relevant documents.
      other_documents = Document.where.not(id: document.id).where.not(embeddings: nil)

      is_plagiarized = false
      document.embeddings.each do |doc_embedding|
        other_documents.each do |other_doc|
          other_doc.embeddings.each do |other_embedding|
            distance = Pgvector::Vector.cosine_distance(doc_embedding, other_embedding)
            # A lower cosine distance means higher similarity. Threshold of 0.2 is arbitrary.
            if distance < 0.2
              is_plagiarized = true
              break
            end
          end
          break if is_plagiarized
        end
        break if is_plagiarized
      end

      if is_plagiarized
        document.update!(plagiarism_status: :plagiarized)
      else
        document.update!(plagiarism_status: :unique)
      end
    rescue => e
      Rails.logger.error "Failed to perform plagiarism check for document #{document.id}: #{e.message}"
      # Optionally set a failed status for plagiarism check
    end
  end
end
