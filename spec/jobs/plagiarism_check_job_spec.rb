require 'rails_helper'

RSpec.describe PlagiarismCheckJob, type: :job do
  include ActiveJob::TestHelper

  let(:document) { create(:document, embeddings: [[0.1, 0.2, 0.3]]) }

  it "sets the plagiarism_status to unique if no similar documents are found" do
    perform_enqueued_jobs { described_class.perform_later(document.id) }
    document.reload
    expect(document.plagiarism_status).to eq('unique')
  end

  it "sets the plagiarism_status to plagiarized if similar documents are found" do
    create(:document, embeddings: [[0.11, 0.21, 0.31]]) # A similar document
    perform_enqueued_jobs { described_class.perform_later(document.id) }
    document.reload
    expect(document.plagiarism_status).to eq('plagiarized')
  end
end
