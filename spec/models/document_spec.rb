require 'rails_helper'

RSpec.describe Document, type: :model do
  it "is valid with valid attributes" do
    document = build(:document)
    expect(document).to be_valid
  end

  it "is not valid without a file" do
    document = build(:document, file: nil)
    expect(document).to_not be_valid
  end

  it "is not valid with a file larger than 20MB" do
    document = build(:document)
    document.file.attach(
      io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'large_file.pdf')),
      filename: 'large_file.pdf',
      content_type: 'application/pdf'
    )
    expect(document).to_not be_valid
  end

  it "is not valid with a file of an invalid content type" do
    document = build(:document)
    document.file.attach(
      io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.txt')),
      filename: 'test.txt',
      content_type: 'text/plain'
    )
    expect(document).to be_valid
  end

  it "has a default plagiarism_status of not_checked" do
    document = create(:document)
    expect(document.plagiarism_status).to eq('not_checked')
  end

  it "can have embeddings" do
    document = create(:document, embeddings: [1.0, 2.0, 3.0])
    expect(document.embeddings).to eq([1.0, 2.0, 3.0])
  end
end
