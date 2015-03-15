class DocumentsController < ApplicationController
  layout "logged_in"
  before_action :authenticate_user!
  before_filter :document_exists

  def show_details
    document_id = params[:id]
    @message = "Document itself"        
    @document = Document.find_by_id(document_id)
  end

  def edit_details
    document_id = params[:id]
    @message = "Document form should be added here"
    @document = Document.find_by_id(document_id)
  end

  def update_details
    document_id = params[:document][:id]
    document = Document.find_by_id(document_id)
    document.update_attributes( document_params )
    redirect_to document_details_path(document_id)
  end

  def create
    @document = current_user.documents.create(params[:document])
  end

  #BEFORE FILTER methods
  private

  def document_exists
      document_exists = Document.exists?(params[:id])
      if not document_exists
        render_404
        return false
      else
        return true
      end
  end

  #PERMITTING mass assignment
  def document_params
    params.require(:document).permit(:name )
  end


end
