ActiveAdmin.register ReportedInappropriate do


  # scope :recent
  # scope :abuse
  # scope :irrelavent
  # scope :urgent

  controller do

	  def new
	   	@reported_inappropriate = ReportedInappropriate.new
       	authorize_me_to( :create , @reported_inappropriate )        	
	  end

	  def create
	   	@reported_inappropriate = ReportedInappropriate.new( permitted_params[:reported_inappropriate] )
      	authorize_me_to( :create , @reported_inappropriate )
	    create!
	  end

      def edit
        @reported_inappropriate = ReportedInappropriate.find_by_id(params[:id])
        authorize_me_to( :update , @reported_inappropriate )
      end

      def update
      	@reported_inappropriate = ReportedInappropriate.new( params[:id])
        authorize_me_to( :update , @reported_inappropriate )        
        @bucket.update_attributes(permitted_params[:bucket])
        create!
      end


      def destroy
      	@reported_inappropriate = ReportedInappropriate.new( params[:id])
        authorize_me_to( :destroy , @reported_inappropriate )
        destroy!
      end


   end



  index do 
      selectable_column
      column :user_id do |report|
	    user = User.find_by_id(report.user_id)
	    link_to( user.full_name , admin_user_path( user.id ) )
      end

      column :bucket_id do |report|
      	bucket = Bucket.find_by_id(report.bucket_id)
	    link_to( bucket.name , admin_bucket_path( bucket ) )
      end

      column :created_at do |report|
      	"#{time_ago_in_words(report.created_at)} ago"
      end

      actions
  end


  show do
      panel "Bucket Details" do
        attributes_table_for reported_inappropriate do
        	bucket = reported_inappropriate.bucket
            row("Name")   { bucket.name }
            row("Size")   { bucket.size }
            row("Created")  { time_ago_in_words(bucket.created_at)  }
            row("UpVotes")  { bucket.up_votes }
            row("DownVotes"){ bucket.down_votes }
            row("Downloads"){ bucket.downloads.size }
        end
      end
      panel "User Details" do
        attributes_table_for reported_inappropriate do
        	user = reported_inappropriate.user
            row("Name")   { user.full_name }
            row("Email")   { user.email }
            row("College")   { (@user.college.name rescue "None yet" ) }
            row("Branch")    { (@user.branch.name rescue "None yet" ) }
            row("On Platform ")   { time_ago_in_words(user.created_at) }
            row("Reputation")  { user.reputation  }
            row("Downloaded ") { number_to_human_size(user.downloaded_data_size) }
            row("Uploaded   ") { number_to_human_size(user.uploaded_data_size) }
            row("Downloads"){ user.downloads.size }
        end
      end

      panel "Comment Threads" do
		table_for reported_inappropriate.bucket.comments do

            column "User" do |comment|
            	user = comment.user
				link_to( user.full_name , admin_user_path( user.id ) )
            end
            
            column "Thread Message" do |comment|
            	comment.message
            end

            column "Details" do |comment|
            	link_to( "view" , admin_comment_path( comment.id ) )
            end
        end
      end

  end


end