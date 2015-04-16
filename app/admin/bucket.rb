ActiveAdmin.register Bucket do
  menu label: "User Buckets" , :priority => 6

  permit_params :name, :description  , :user_id , :category_id , :course_id

  belongs_to :course , :optional => true


  controller do
      # authorize_resource
      # include ActiveAdminCanCan

	    def new
	      @bucket = Bucket.new
        authorize_me_to( :create , @bucket )
        @bucket.course_id = params[:course_id]
	    end

	    def create
	      @bucket = Bucket.new( permitted_params[:bucket] )
        authorize_me_to( :create , @bucket )

        @course = Course.find_by_id(params[:course_id])
	      @bucket.user_id = current_user.id

	      @course.buckets << @bucket
        create! do |format|
            format.html { redirect_to admin_course_path( @course ) }
        end
	    end

      def edit
        @bucket = Bucket.find_by_id(params[:id])
        authorize_me_to( :update , @bucket )
        @bucket.course_id = params[:course_id]
      end

      def update
        @bucket = Bucket.find_by_id(params[:id])
        authorize_me_to( :update , @bucket )
        @bucket.update_attributes(permitted_params[:bucket])
        update! do |format|
            format.html { redirect_to admin_course_path( @course ) }
        end
      end


      def destroy
        @bucket = Bucket.find_by_id(params[:id])
        authorize_me_to( :destroy , @bucket )
        destroy! do |format|
            format.html { redirect_to :back }
        end
      end


   end

  active_admin_allowed_action_items

  index do
      selectable_column
      column :name
      column :description 
      column :category do |bucket|
          status_tag(bucket.category.category , :ok)
      end
      column :created_at do |bucket|
          "Created #{time_ago_in_words(bucket.created_at)} ago"
      end
      column :user_id do |bucket|
          # bucket.uploader.full_name
      end
      actions
  end

  show do
      panel "Bucket Details" do
        attributes_table_for bucket do
            row("Bucket  Name")   { bucket.name }
            row("Course  Name")  { bucket.course.name  }
            row("College Name")   { bucket.course.college.name  }
            row("Branch  Name")   { bucket.course.branch.name  }
            row("Uploader") {bucket.uploader.full_name}
        end
      end
      panel "Folders" do
            table_for bucket.folders.where(:folder_id => nil ) do
                column "Name" do |folder|
                  link_to( folder.name , admin_bucket_folder_path( bucket , folder ) ) 
                end
                column "View" do |folder|
                  link_to( "View" , admin_bucket_folder_path( bucket , folder ) ) 
                end
                column "Edit" do |folder|
                  link_to( "Edit" , edit_admin_bucket_folder_path( bucket , folder )  ) if can?(:edit , folder )
                end
                column "Destroy" do |folder|
                  # link_to( "Remove" , admin_folder_path(folder) , :method => :delete , data: { confirm: "Are you sure u want to delete this folder ?" } )  if can?(:destroy , folder )
                end
            end
            span link_to( "Create Folder within" , new_admin_bucket_folder_path( bucket ) )  if can?(:create , Folder )
            # span link_to( "View all Folders within" , admin_bucket_folders_path( bucket ) )
      end
      panel "Documents" do
            table_for bucket.documents.where(:folder_id => nil ) do
                column "Name" do |document|
                    link_to( document.name , admin_bucket_document_path( bucket , document ) ) 
                end
                column "View" do |document|
                    link_to( document.name , admin_bucket_document_path( bucket , document ) ) 
                end
                column "Edit" do |document|
                    link_to( "Edit" , edit_admin_bucket_document_path( bucket , document )  ) if can?(:edit , document )
                end
                column "Destroy" do |document|
                    link_to( "Remove" , admin_document_path(document) , :method => :delete , data: { confirm: "Are you sure u want to delete this document ?" } ) if can?(:destroy , document )
                end
            end
            span link_to( "Create Document within" , new_admin_bucket_document_path( bucket ) ) if can?(:destroy , Document )
            # render 'upload_documents_in_bucket'
            render(:partial => 'shared/upload_documents' , :locals => {:parent => bucket })
      end
      panel "Bucket Comments" do
            table_for bucket.comments do
                column "Name" do |comment|
                    user = comment.user
                    link_to( user.full_name , admin_user_path( user ) ) 
                end
                column "Title Thread" do |comment|
                    link_to( comment.message , admin_comment_path( comment ) ) 
                end
                column "Destroy" do |comment|
                    link_to( "Remove" , admin_comment_path(document) , :method => :delete , data: { confirm: "Are you sure u want to delete this document ?" } ) if can?(:destroy , document )
                end
            end
            # span link_to( "Create Document within" , new_admin_bucket_document_path( bucket ) ) if can?(:destroy , Document )
            # render 'upload_documents_in_bucket'
            # render(:partial => 'shared/upload_documents' , :locals => {:parent => bucket })
      end
      active_admin_comments
  end




  form do |f|    
      f.semantic_errors *f.object.errors.keys
      f.inputs "Bucket Details" do
          f.input :name 
          if f.object.course_id.nil?
	          f.input :course   , as: :select ,  input_html: { :class => 'chosen-input' }  , :label => "Choose Course"
          else
            f.input :course_id, :as => :hidden ,  input_html: { :value => f.object.course_id }             
          end
          f.input :category , as: :select ,  input_html: { :class => 'chosen-input' }  , :label => "Choose Category"
          f.input :description
      end
      f.actions
  end


  filter :name , :label => "Bucket name"
  filter :by_college_name_in, label: "College", as: :select, collection: proc { College.order(:name) },  input_html: { class: 'chosen-input' }
  filter :by_branch_name_in,  label: "Branch"  , as: :select, collection: proc { Branch.order(:name)  },  input_html: { class: 'chosen-input' }
  filter :by_course_name_in,  label: "Course"  , as: :select, collection: proc { Course.order(:name)  },  input_html: { class: 'chosen-input' }
  
  
  
  sidebar "Any thing can be added here", only: [:show ] do
    ul do
      # li link_to "Branches" , admin_college_branches_path( college )
        # span link_to( "View all Course" , admin_courses_path )              
    end
  end
  sidebar "Any thing can be added here", only: [:show ] do
    ul do
      # li link_to "Branches" , admin_college_branches_path( college )
    end
  end
  sidebar "Any thing can be added here", only: [:show ] do
    ul do
      # li link_to "Branches" , admin_college_branches_path( college )
    end
  end



end



