require "pdf-reader"
require "docx"

class DocumentProcessingJob < ApplicationJob
  queue_as :default

  def perform(document_id)
    document = Document.find(document_id)
    return unless document

    begin
      extracted_text = extract_text_from_file(document)
      chunks = chunk_text(extracted_text)
      embeddings = generate_embeddings(chunks)

      document.update!(extracted_text: extracted_text, embeddings: embeddings, status: :completed)
      PlagiarismCheckJob.perform_async(document.id)
    rescue => e
      document.update!(status: :failed)
      Rails.logger.error "Failed to process document #{document.id}: #{e.message}"
    end
  end

  private

  def extract_text_from_file(document)
    document.file.open do |file|
      case document.file.content_type
      when "application/pdf"
        reader = PDF::Reader.new(file)
        reader.pages.map(&:text).join('\n')
      when "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        doc = Docx::Document.open(file)
        doc.paragraphs.map(&:text).join('\n')
      when "text/plain"
        file.read
      else
        raise "Unsupported content type: #{document.file.content_type}"
      end
    end
  end

  def chunk_text(text, chunk_size: 1000, overlap: 200)
    # Simple chunking by splitting into sentences and then grouping them
    sentences = text.split(/(?<=[.!?])\s+/)
    chunks = []
    current_chunk = []
    current_length = 0

    sentences.each do |sentence|
      if current_length + sentence.length + 1 > chunk_size && current_chunk.any?
        chunks << current_chunk.join(" ")
        current_chunk = current_chunk.last(overlap).presence || []
        current_length = current_chunk.sum(&:length) + current_chunk.size - 1
      end
      current_chunk << sentence
      current_length += sentence.length + 1
    end
    chunks << current_chunk.join(" ") if current_chunk.any?
    chunks.compact_blank
  end

  def generate_embeddings(chunks)
    client = OpenAI::Client.new
    embeddings = []
    chunks.each do |chunk|
      response = client.embeddings(parameters: { model: "text-embedding-ada-002", input: chunk })
      embeddings << response["data"][0]["embedding"]
    end
    embeddings
  end
end
