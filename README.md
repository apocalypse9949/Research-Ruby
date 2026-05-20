# Document Processor & Plagiarism Checker API

This is a Ruby on Rails API application designed to process uploaded documents, generate semantic embeddings using OpenAI, and perform automated plagiarism checks against other documents in the database using `pgvector`.

## Features

- **Document Uploads**: Users can upload `.pdf`, `.docx`, and `.txt` files through the API.
- **Background Processing**: Heavy lifting is handled asynchronously using Sidekiq and ActiveJob.
- **Text Extraction**: Extracts text from various document formats (PDFs, Word documents, plain text).
- **Semantic Chunking & Embeddings**: Text is chunked and transformed into semantic vectors using OpenAI's `text-embedding-ada-002` model.
- **Plagiarism Detection**: Utilizes PostgreSQL with the `pgvector` extension to perform cosine similarity searches across all processed documents, flagging potential plagiarism based on semantic similarity.
- **Authentication**: Secured with Devise.

## Core Components

- **`DocumentProcessingJob`**: Handles text extraction, text chunking, and embedding generation using the OpenAI API.
- **`PlagiarismCheckJob`**: Runs after document processing to compare the new document's embeddings against all other documents in the database using pgvector's cosine distance calculations.
- **`Api::V1::UploadsController`**: API endpoint for uploading and checking the status of documents.

## Requirements

- Ruby 3.3.7
- Rails 7.1+
- PostgreSQL with `pgvector` extension enabled
- Redis (for Sidekiq)
- OpenAI API Key

## Setup

Ensure you have your environment variables set up, particularly your OpenAI API key and database credentials.

* Database creation: `rails db:create`
* Database initialization: `rails db:migrate`
* Start server: `rails s`
* Start Sidekiq: `bundle exec sidekiq`
