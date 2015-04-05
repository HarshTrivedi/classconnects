ActiveAdmin.register Folder do  
  menu false

  permit_params :name , :folder_id , :bucket_id
  config.filters = false
  config.paginate = false
  belongs_to :bucket , :optional => true
  # belongs_to :folder, :optional => true




  controller do

      def new
        @folder = Folder.new
        authorize_me_to( :create , @folder )

        @folder.folder_id = params[:folder_id]
        @folder.bucket_id = params[:bucket_id]
      end

      def create
        @folder = Folder.new( permitted_params[:folder] )
        authorize_me_to( :create , @folder )

        @parent_folder = Folder.find_by_id( (params[:folder][:folder_id] rescue nil)) 
        @parent_bucket = Bucket.find_by_id(params[:bucket_id]) 
        
        if @parent_folder
          @parent_folder.folders << @folder 
          @folder.parent = @parent_folder
          # Folder.create!( :name => 'Stinky', :parent => @parent_folder)
        end

        @parent_bucket.folders << @folder

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

      def edit
        @folder = Folder.find_by_id(params[:id])
        authorize_me_to( :create , @folder )

        @folder.folder_id = params[:folder_id]
        @folder.bucket_id = params[:bucket_id]
      end

      def update
        @folder = Folder.find_by_id( params[:id] )
        authorize_me_to( :update , @folder )

        @parent_folder = Folder.find_by_id( (params[:folder][:folder_id] rescue nil)) 
        @parent_bucket = Bucket.find_by_id(params[:bucket_id])         
    		@folder.update_attributes(permitted_params[:folder])

        if @parent_folder
            update! do |format|
                format.html { redirect_to admin_bucket_folder_path( @bucket , @parent_folder ) }
            end
        else
            update! do |format|
                format.html { redirect_to admin_bucket_path( @bucket ) }
            end
        end

      end

      def destroy
        @folder = Folder.find_by_id( params[:id] )
        authorize_me_to( :destroy , @folder )
        destroy!
      end


   end

  show do
      panel "Folder Details" do
        attributes_table_for folder do
            row("Folder  Name")   { folder.name }
            row("Bucket  Name")  { folder.bucket.name  }
            row("Uploader") {folder.bucket.uploader.full_name}
        end
      end
      panel "Folders" do
            table_for folder.folders do
            	
                column "Name" do |child_folder|
	                  link_to( child_folder.name , admin_bucket_folder_path( folder.bucket  , child_folder ) ) 
                end
                column "View" do |child_folder|
	                  link_to( "View" , admin_bucket_folder_path( folder.bucket  , child_folder ) ) 
                end
                column "Edit" do |child_folder|
	                  link_to( "Edit" , edit_admin_bucket_folder_path( :bucket_id => folder.bucket.id  , :id => child_folder , :folder_id => folder.id )  ) if can?(:edit , child_folder )
                end
                column "Destroy" do |child_folder|
    	              link_to( "Remove" , admin_folder_path(child_folder) , :method => :delete , data: { confirm: "Are you sure u want to delete this folder ?" } )  if can?(:destroy , child_folder )
                end
                
            end
            span link_to( "Create Folder within" , new_admin_bucket_folder_path( :bucket_id => bucket.id , :folder_id => folder.id ) )  if can?(:create , Folder )
      end
      panel "Documents" do
            table_for folder.documents do
                column "Name" do |document|
	                  link_to( document.name , admin_bucket_document_path( folder.bucket , document ) ) 
                end
                column "View" do |document|
    	              link_to( document.name , admin_bucket_document_path( folder.bucket , document ) ) 
                end
                column "Edit" do |document|
	                  link_to( "Edit" , edit_admin_bucket_document_path( :bucket_id => folder.bucket.id  , :id => document , :document_id => document.id )  )
                end
                column "Destroy" do |document|
    	              link_to( "Remove" , admin_document_path(document) , :method => :delete , data: { confirm: "Are you sure u want to delete this document ?" } ) 
                end
                
            end
            span link_to( "Create Document within" , new_admin_bucket_document_path( :bucket_id => bucket.id , :folder_id => folder.id ) )  if can?(:create , Document )
            render(:partial => 'shared/upload_documents' , :locals => {:parent => folder })
      end
      active_admin_comments
  end

   form do |f|
        f.semantic_errors *f.object.errors.keys
        f.inputs "Folder Details" do
            f.input :name
            f.input :folder_id, :as => :hidden ,  input_html: { :value => f.object.folder_id } 
        end
        f.actions
   end




  sidebar "Navigate in Folder", only: [:show ] do
      raw(Folder.find_by_id(folder.root_id).subtree_html)
  end

  sidebar "Go back to Bucket Root", only: [:show ] do
    ul do
      bucket = folder.bucket
      li link_to bucket.name , admin_bucket_path( bucket )
    end
  end

  sidebar "Any thing can be added here", only: [:show ] do
    subtree = folder.subtree.arrange_serializable

      ul do
      end
  end



end


















  # working code for sortable tree
  # sortable tree: true,
  #          sorting_attribute: :position,
  #          parent_method: :parent,
  #          children_method: :children_with_documents,
  #          # roots_method: :roots,
  #          roots_collection: proc { Folder.where(:id => 1) },
  #          collapsible: true,
  #          start_collapsed: true

  #   index as: :sortable do
  #       label :name

  #   end
