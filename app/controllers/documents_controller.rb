class DocumentsController < ApplicationController
  layout "logged_in"
  before_action :authenticate_user!
  before_filter :document_exists , :except => ["new_document" , "create_document"]

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

  def create_document

    # params => {   "url"=>"https://classcollabdevelopment.s3.amazonaws.com/uploads%2F1426451367919-l6fr3qa6dur6n7b9-47564170fe673ff8b02dffe27e5e0d9a%2F500.html", 
    #               "filepath"=>"/uploads%2F1426451367919-l6fr3qa6dur6n7b9-47564170fe673ff8b02dffe27e5e0d9a%2F500.html", 
    #               "filename"=>"500.html", 
    #               "filesize"=>"1477", 
    #               "filetype"=>"text/html", 
    #               "unique_id"=>"l6fr3qa6dur6n7b9", 
    #               "document"=>"https://classcollabdevelopment.s3.amazonaws.com/uploads%2F1426451367919-l6fr3qa6dur6n7b9-47564170fe673ff8b02dffe27e5e0d9a%2F500.html"
    #           }

    s3 = params
    name = s3["filename"]
    cloud_path = s3["url"]
    folder_id = s3["folder_id"]
    folder = Folder.find_by_id(folder_id)
    if not folder.nil? 
        Document.create(:folder_id => folder_id , cloud_path => cloud_path , :s3 => s3)
    end

    render js: "window.location = '/' "

  end


  def new_document

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
