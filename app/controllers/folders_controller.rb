class FoldersController < ApplicationController
  layout "logged_in"
  before_action :authenticate_user!
  before_filter :folder_exists , :except => [:new_folder , :create_folder]
  respond_to :html , :js


  def show_content
    folder_id = params[:id]
    search = params[:search] || ""
    @folder = Folder.find_by_id(folder_id)
    @message = "Folder specific folders and documents"    
    @folders = @folder.folders.order(:created_at).search(search).page(params[:folder_page])
    @documents = @folder.documents.order(:created_at).search(search).page(params[:document_page])
  end

  def show_details
    folder_id = params[:id]
    @message = "Folder itself"        
    @folder = Folder.find_by_id(folder_id)
  end

  def edit_details
    folder_id = params[:id]
    @message = "Folder form should be added"
    @folder = Folder.find_by_id(folder_id)

    ### Form will have to be shown for this

  end

  def update_details
    folder_id = params[:folder][:id]
    @folder = Folder.find_by_id(folder_id)
    @folder.update_attributes( folder_params )

    respond_to do |format|
      format.js
    end

  end

  def new_folder
    @parent_type = params[:parent_type]
    @parent_id = params[:parent_id]
    @folder = Folder.new
  end


  def create_folder
    
    @parent_type = params[:parent_type]
    @parent_id = params[:parent_id]

    if @parent_type == "bucket"
        @parent_bucket = Bucket.find_by_id(  @parent_id  )
        @folder = Folder.new( :name => params[:folder][:name] )
        @parent_bucket.folders << @folder
    elsif @parent_type == "folder"
        @folder = Folder.new( :name => params[:folder][:name] )
        @parent_folder = Folder.find_by_id(  @parent_id  )        
        if @parent_folder
            @parent_folder.folders << @folder 
            @folder.parent = @parent_folder
        end
        @parent_bucket = @parent_folder.bucket
        @parent_bucket.folders << @folder
    end

    respond_to do |format|
      format.js
    end

  end


  #ie remove from the uploads
  def destroy_folder
    folder_id = params[:id]
    @folder = Folder.find_by_id(folder_id)
    @folder.destroy if current_user == @folder.bucket.uploader
    # redirect_to :back
    respond_to do |format|
      format.js
    end

  end


  #BEFORE FILTER methods
  private

  def folder_exists
      folder_exists = Folder.exists?(params[:id])
      if not folder_exists
        render_404
        return false
      else
        return true
      end
  end

  #PERMITTING mass assignment
  def folder_params
    params.require(:folder).permit(:name )
  end


end
