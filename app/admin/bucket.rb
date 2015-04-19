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
            format.html {
              if @bucket.valid?
                redirect_to admin_course_path( @course ) 
              else
                 render 'new'
              end
            }
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
            format.html { 
              if @bucket.valid?
                redirect_to admin_course_path( @course ) 
              else
                render 'new'
              end
            }
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
          :method => :delete , data: { confirm: "Are you sure u want to delete this Resource ?" }   )
      end
    end


  index do
      selectable_column
      column :name
      column :user_id do |bucket|
          bucket.uploader.full_name
      end
      column :description 
      column :category do |bucket|
          status_tag(bucket.category.category , :ok)
      end
      column :created_at do |bucket|
          "Created #{time_ago_in_words(bucket.created_at)} ago"
      end
      actions
  end

  show do
      panel "Bucket Details" do
        attributes_table_for bucket do
            row("Bucket  Name")   { bucket.name }
            row("Course  Name")  { bucket.course.name  }
            row("College Name")   { link_to( bucket.course.college.name , admin_college_path(bucket.course.college) )   }
            row("Branch  Name")   { link_to( bucket.course.branch.name , admin_branch_path( bucket.course.branch ) )  }
            uploader = bucket.uploader
            row("Uploader") { link_to( uploader.full_name , admin_user_path( uploader ) )   }
            row("Size") { number_to_human_size(bucket.size)  }
            row("Created") { time_ago_in_words( bucket.created_at )  }
        end
      end
      panel "Folders" do
            table_for bucket.folders.where(:folder_id => nil ) do
                column "Name" do |folder|
                  link_to( folder.name , admin_bucket_folder_path( bucket , folder ) ) 
                end
                column "Size" do |folder|
                    number_to_human_size(folder.size)
                end 
                column "View" do |folder|
                  link_to( "View" , admin_bucket_folder_path( bucket , folder ) ) 
                end
                column "Edit" do |folder|
                  link_to( "Edit" , edit_admin_bucket_folder_path( bucket , folder )  ) if can?(:edit , folder )
                end
                column "Destroy" do |folder|
                  link_to( "Remove" , admin_folder_path(folder) , :method => :delete , data: { confirm: "Are you sure u want to delete this folder ?" } )  if can?(:destroy , folder )
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
                column "Size" do |document|
                    number_to_human_size(document.size)
                end 
                column "Type" do |document|
                    document.type 
                end
                column "Download" do |document|
                    link_to( "download" , download_document_path(document.id) ) 
                end
                column "Edit" do |document|
                    link_to( "Edit" , edit_admin_bucket_document_path( bucket , document )  ) if can?(:edit , document )
                end
                column "Destroy" do |document|
                    link_to( "Remove" , admin_document_path(document) , :method => :delete , data: { confirm: "Are you sure u want to delete this document ?" } ) if can?(:destroy , document )
                end
            end
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
  


end



