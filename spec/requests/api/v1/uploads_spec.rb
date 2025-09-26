require 'rails_helper'

RSpec.describe "Api::V1::Uploads", type: :request do
  describe "GET /api/v1/uploads" do
    it "returns a list of documents" do
      create_list(:document, 3)
      get "/api/v1/uploads"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe "GET /api/v1/uploads/:id" do
    it "returns a document" do
      document = create(:document)
      get "/api/v1/uploads/#{document.id}"
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['id']).to eq(document.id)
    end
  end

  describe "POST /api/v1/uploads" do
    it "creates a new document" do
      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test.pdf'), 'application/pdf')
      expect {
        post "/api/v1/uploads", params: { document: { file: file } }
      }.to change(Document, :count).by(1)
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['status']).to eq('processing')
    end
  end
end
