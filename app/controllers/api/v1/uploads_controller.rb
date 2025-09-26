class Api::V1::UploadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_document, only: [:show]

  def index
    @documents = Document.all
    render json: @documents
  end

  def show
    render json: @document
  end

  def create
    @document = Document.new(document_params)
    @document.status = :processing

    if @document.save
      DocumentProcessingJob.perform_async(@document.id)
      render json: { id: @document.id, status: @document.status }, status: :created
    else
      render json: @document.errors, status: :unprocessable_entity
    end
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:file)
  end
end
