class FoldersController < ApplicationController
  before_action :authenticate_user!
  before_filter :folder_exists

  def show_content
    folder_id = params[:id]
    folder = Folder.find_by_id(folder_id)
    @message = "Folder specific folders and documents"    
    @folders = folder.folders.page(params[:page])
    @documents = folder.documents.page(params[:page])
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
    folder = Folder.find_by_id(folder_id)
    folder.update_attributes( folder_params )
    redirect_to folder_details_path(folder_id)
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
