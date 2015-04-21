class DocumentsController < ApplicationController
  layout "logged_in"
  before_action :authenticate_user!
  before_filter :document_exists , :except => ["new_document" , "create_document"]
<<<<<<< HEAD

=======
  before_filter :authenticate_access_document , :except => [:new_document , :create_document ]
>>>>>>> tempclasscollab/master
  skip_before_filter :verify_authenticity_token, :only => [:create_document]



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
<<<<<<< HEAD
    document = Document.find_by_id(document_id)
    document.update_attributes( document_params )
    redirect_to :back
=======
    @document = Document.find_by_id(document_id)
    @document.update_attributes( document_params )
    respond_to do |format|
      format.js
    end
>>>>>>> tempclasscollab/master
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
    logger.ap params
    s3 = params
    name = s3["filename"]
    cloud_path = s3["url"]

    parent_type = params["parent_type"]
    parent_id =   params["parent_id"]
<<<<<<< HEAD
=======
    ap parent_type
    ap parent_id
>>>>>>> tempclasscollab/master

    if parent_type == "folder"
        folder = Folder.find_by_id(parent_id)
        if not folder.nil? 
            # logger.ap "Folder"
<<<<<<< HEAD
            document = Document.create( :name => name ,  :folder_id => parent_id , :bucket_id => folder.bucket_id , :cloud_path => cloud_path , :s3 => s3)
            # logger.ap document.valid?
            # logger.ap document
            bucket = Bucket.find_by_id(folder.bucket_id)
            bucket.size = bucket.size + s3["filesize"]
=======
            @document = Document.create( :name => name ,  :folder_id => parent_id.to_i , :bucket_id => folder.bucket.id , :cloud_path => cloud_path , :s3 => s3)
            ap @document
            ap @document.errors
            # logger.ap document.valid?
            # logger.ap document
            bucket = Bucket.find_by_id(folder.bucket.id)
            ap bucket
            bucket.size = bucket.size.to_i + s3["filesize"].to_i
>>>>>>> tempclasscollab/master
            bucket.save
        end
    elsif parent_type == "bucket"
        bucket = Bucket.find_by_id(parent_id)
        if not bucket.nil? 
            # logger.ap "Bucket"
<<<<<<< HEAD
            Document.create( :name => name , :bucket_id => parent_id , :cloud_path => cloud_path , :s3 => s3)
            # logger.ap document.valid?
            # logger.ap document
            bucket.size = bucket.size + s3["filesize"].to_i
=======
            @document = Document.create( :name => name , :bucket_id => parent_id.to_i , :cloud_path => cloud_path , :s3 => s3)
            ap @document
            ap @document.errors

            # logger.ap document.valid?
            # logger.ap document
            bucket.size = bucket.size.to_i + s3["filesize"].to_i
            ap bucket
>>>>>>> tempclasscollab/master
            bucket.save
        end
    end
    uploader = bucket.uploader
    uploader.uploaded_data_size = uploader.uploaded_data_size + s3["filesize"].to_i
    uploader.save
    # redirect_to :back
    #Need to render JS over here!
<<<<<<< HEAD
    render :nothing => true
=======
    respond_to do |format|
      format.js
    end
>>>>>>> tempclasscollab/master
  end


  def new_document
    @parent_type = "bucket"
    @parent_id = 1
  end

  #ie remove from the uploads
  def destroy_document
<<<<<<< HEAD
    document_id = params[:document_id]
    document = Document.find_by_id(document_id)
    document_id.destroy if current_user == document.bucket.uploader
    redirect_to :back
=======
    document_id = params[:id]
    @document = Document.find_by_id(document_id)
    uploader = @document.bucket.uploader
    if current_user == uploader
      @document.destroy
      uploader.uploaded_data_size = uploader.uploaded_data_size - @document.size
      uploader.save       
    end
    # redirect_to :back
    respond_to do |format|
      format.js
    end

>>>>>>> tempclasscollab/master
  end


  def view_document

    document = Document.find_by_id(params[:id])

    path = document.cloud_path
    filename = document.name

    doc = BoxView::Api::Document.new.upload( path , filename )
<<<<<<< HEAD

=======
    
>>>>>>> tempclasscollab/master
    document_session = doc.document_session
    view_url = document_session.view_url

    redirect_to view_url
    
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

<<<<<<< HEAD
=======
  def authenticate_access_document
      document = Document.find_by_id(params[:id])
      bucket = document.bucket
      if not bucket.privately_shared
        return true
      else
        if bucket.college == current_user.college
          return true
        else
          return false
        end
      end
  end

>>>>>>> tempclasscollab/master
  #PERMITTING mass assignment
  def document_params
    params.require(:document).permit(:name )
  end


end
