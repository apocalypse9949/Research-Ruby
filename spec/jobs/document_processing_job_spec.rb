require 'rails_helper'

RSpec.describe DocumentProcessingJob, type: :job do
  include ActiveJob::TestHelper

  let(:document) { create(:document) }
  let(:openai_client) { instance_double(OpenAI::Client) }

  before do
    allow(OpenAI::Client).to receive(:new).and_return(openai_client)
    allow(openai_client).to receive(:embeddings).and_return({
      'data' => [{'embedding' => [0.1, 0.2, 0.3]}]
    })
  end

  it "updates the document status to completed and extracts text" do
    perform_enqueued_jobs { described_class.perform_later(document.id) }
    document.reload
    expect(document.status).to eq('completed')
    expect(document.extracted_text).to_not be_nil
    expect(document.embeddings).to_not be_nil
  end

  it "enqueues the PlagiarismCheckJob" do
    expect { perform_enqueued_jobs { described_class.perform_later(document.id) } }.
      to have_enqueued_job(PlagiarismCheckJob).with(document.id)
  end
end
