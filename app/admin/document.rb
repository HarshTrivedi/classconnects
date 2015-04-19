ActiveAdmin.register Document do
  menu false
  permit_params :cloud_path , :bucket_id , :folder_id , :name
  belongs_to :bucket, :optional => true
  # belongs_to :folder, :optional => true


  # store_admin_bucket_documents POST     /admin/buckets/:bucket_id/documents/store(.:format)
  # store_admin_documents POST     /admin/documents/store(.:format)
  collection_action :store , method: 'post' do
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
        if parent_type == "folder"
            folder = Folder.find_by_id(parent_id)
            if not folder.nil? 
                # logger.ap "Folder"
                document = Document.create( :name => name ,  :folder_id => parent_id , :bucket_id => folder.bucket_id , :cloud_path => cloud_path , :s3 => s3)
                # logger.ap document.valid?
                # logger.ap document
                bucket = Bucket.find_by_id(folder.bucket_id)
                bucket.size = bucket.size + s3["filesize"]
                bucket.save
            end
        elsif parent_type == "bucket"
            bucket = Bucket.find_by_id(parent_id)
            if not bucket.nil? 
                # logger.ap "Bucket"
                Document.create( :name => name , :bucket_id => parent_id , :cloud_path => cloud_path , :s3 => s3)
                # logger.ap document.valid?
                # logger.ap document
                bucket.size = bucket.size + s3["filesize"].to_i
                bucket.save
            end
        end
        uploader = bucket.uploader
        uploader.uploaded_data_size = uploader.uploaded_data_size + s3["filesize"].to_i
        uploader.save
        # redirect_to :back
        render :js => "alert( Uploaded #{name} )"
        # render :nothing => true
  end



    config.clear_action_items!   
    action_item :except => [:new, :show , :index ] do
      if can?(:create, active_admin_config.resource_class) && controller.action_methods.include?('new')
        link_to(I18n.t('active_admin.new_model', :model => active_admin_config.resource_name), new_resource_path)
      end
    end
   
    action_item :only => [:show] do
      if can?(:update, resource) && controller.action_methods.include?('edit')
        link_to(I18n.t('active_admin.edit_model', :model => active_admin_config.resource_name), edit_resource_path(resource))
      end
    end
   
    action_item :only => [:show] do
      # Destroy link on show
      if can?(:destroy, resource) && controller.action_methods.include?("destroy")
        link_to(I18n.t('active_admin.delete_model', :model => active_admin_config.resource_name), resource_path(resource),
          :method => :delete , data: { confirm: "Are you sure u want to delete this Resource ?" }  )
      end
    end




  controller do

      def new
        @document = Document.new
        authorize_me_to( :create , @document )

        @document.folder_id = params[:folder_id]
        @document.bucket_id = params[:bucket_id]
      end

      def create
        # @document = Document.new( permitted_params[:document] )
        # authorize_me_to( :create , @document )

        # @parent_folder = Folder.find_by_id( (params[:folder][:folder_id] rescue nil)) 
        # @parent_bucket = Bucket.find_by_id(params[:bucket_id]) 
        
        # @parent_folder.documents << @document if @parent_folder
        # @parent_bucket.documents << @document

        # if @parent_folder
        #     create! do |format|
        #         format.html { redirect_to admin_bucket_folder_path( @bucket , @parent_folder ) }
        #     end
        # else
        #     create! do |format|
        #         format.html { redirect_to admin_bucket_path( @bucket ) }
        #     end
        # end
            logger.ap params
            s3 = params
            name = s3["filename"]
            cloud_path = s3["url"]
            parent_type = params["parent_type"]
            parent_id =   params["parent_id"]
            if parent_type == "folder"
                folder = Folder.find_by_id(parent_id)
                if not folder.nil? 
                    # logger.ap "Folder"
                    document = Document.create( :name => name ,  :folder_id => parent_id , :bucket_id => folder.bucket_id , :cloud_path => cloud_path , :s3 => s3)
                    # logger.ap document.valid?
                    # logger.ap document
                    bucket = Bucket.find_by_id(folder.bucket_id)
                    bucket.size = bucket.size + s3["filesize"]
                    bucket.save
                end
            elsif parent_type == "bucket"
                bucket = Bucket.find_by_id(parent_id)
                if not bucket.nil? 
                    # logger.ap "Bucket"
                    Document.create( :name => name , :bucket_id => parent_id , :cloud_path => cloud_path , :s3 => s3)
                    # logger.ap document.valid?
                    # logger.ap document
                    bucket.size = bucket.size + s3["filesize"].to_i
                    bucket.save
                end
            end
            uploader = bucket.uploader
            uploader.uploaded_data_size = uploader.uploaded_data_size + s3["filesize"].to_i
            uploader.save
            # redirect_to :back
            render :js => "alert( Uploaded #{name} )"

      end

      def edit
        @document = Document.find_by_id(params[:id])
        authorize_me_to( :create , @document )

        @document.folder_id = params[:folder_id]
        @document.bucket_id = params[:bucket_id]
      end

     def update
        @document = Document.find_by_id( params[:id] )
        authorize_me_to( :create , @document )

        @parent_folder = Folder.find_by_id( (params[:folder][:folder_id] rescue nil)) 
        @parent_bucket = Bucket.find_by_id(params[:bucket_id]) 
        
        @document.update_attributes(permitted_params[:document])

        if @parent_folder
            create! do |format|
                format.html { redirect_to admin_bucket_folder_path( @bucket , @parent_folder ) }
            end
        else
            create! do |format|
                format.html { redirect_to admin_bucket_path( @bucket ) }
            end
        end

      end



      def destroy
        @document = Document.find_by_id( params[:id] )
        authorize_me_to( :create , @document )
        destroy! do |format|
           format.html { redirect_to :back }
        end
      end


      def index
        index! do |format|
            bucket = Bucket.find_by_id(params[:bucket_id])
            folder = Folder.find_by_id(params[:folder_id])
            if folder
                @documents = folder.documents.page(params[:page])
            elsif bucket
                @documents = bucket.documents.where(:folder_id => nil).page(params[:page])
            else
                @documents = Document.all.page(params[:page])
            end
            format.html
        end
      end

   end

  show do
      panel "Document Details" do
        attributes_table_for document do
            # row("Document  Name")   { document.name }
            row("Bucket  Name")  { document.bucket.name  }
            row("Uploader") {document.bucket.uploader.full_name}
        end
      end
      active_admin_comments
  end

  form do |f|    
      f.semantic_errors *f.object.errors.keys
      f.inputs "Document Details" do
          f.input :name 
      end
      f.actions
  end



  filter :name , :label => "Document name"
  filter :by_college_name_in, label: "College", as: :select, collection: proc { College.order(:name) },  input_html: { class: 'chosen-input' }
  filter :by_branch_name_in,  label: "Branch"  , as: :select, collection: proc { Branch.order(:name)  },  input_html: { class: 'chosen-input' }
  filter :by_course_name_in,  label: "Course"  , as: :select, collection: proc { Course.order(:name)  },  input_html: { class: 'chosen-input' }


end
