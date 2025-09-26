FactoryBot.define do
  factory :document do
    status { :processing }
    extracted_text { nil }

    after(:build) do |document|
      document.file.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test.pdf')),
        filename: 'test.pdf',
        content_type: 'application/pdf'
      )
    end
  end
end
