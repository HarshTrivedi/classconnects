namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'faker'
    require 'awesome_print'
    all_models = ActiveRecord::Base.send(:subclasses)
    all_models.delete(AdminUser)

    all_models.each(&:delete_all)
    
    rand(2..4).times do    	
		college = College.create(:name => Faker::Company.name)
	end
    rand(2..4).times do    	
    	branch = Branch.create(:name => Faker::Commerce.department)
    end

    categories = []
    categories << Category.create(:category => "Lecture Slided")
    categories << Category.create(:category => "Exam paper")
    categories << Category.create(:category => "Important")
    categories << Category.create(:category => "collection")
    categories << Category.create(:category => "others")

    users = []
    rand(3..4).times do
    	user = User.create!({:email => Faker::Internet.email , :password => "harshtrivedi", :password_confirmation => "harshtrivedi" })
    	users << user
    end

	courses = []
	buckets = []
    College.all.each do |college|
    	branches = Branch.all
    	college_branch_pairs = []
    	rand(1..3).times do
    		branch = branches.sample
    		college_branch_pairs << CollegeBranchPair.create( :college_id => college.id , :branch_id => branch.id )
    		college.branches << branch
    	end
    	for user in users 
    		UserCollegeBranchEnrollment.create(:user_id => user.id , :college_branch_pair_id => CollegeBranchPair.all.sample.id )
    	end

    	for college_branch_pair in college_branch_pairs
    		rand(1..3).times do
    			course = Course.create(:name => Faker::Lorem.word  , :code => Faker::Code.isbn , :professors => [Faker::Name.name , Faker::Name.name , Faker::Name.name ])
    			courses << course
    			college_branch_pair.courses << course

    			rand(2..3).times do
    				bucket = Bucket.create(:description => Faker::Lorem.sentence , :name => Faker::Commerce.product_name )
    				bucket.category = categories.sample
    				bucket.save
    				buckets << bucket
    				rand(6..7).times do
						folder = Folder.create(:name => Faker::Lorem.word)
    					bucket.folders << folder
    					rand(2..4).times do
    						document = Document.create(:cloud_path => Faker::Internet.url )
    						folder.documents << document
    					end
    				end

    				comments = []
	    			rand(1..5).times do
	    				comment = Comment.create(:user_id => users.sample.id , :message => Faker::Lorem.paragraph(2) , :commentable => college)
	    				comments << comment
	    			end
	    			rand(2..10).times do
	    				comment = Comment.create(:user_id => users.sample.id , :message => Faker::Lorem.paragraph(2) , :commentable => course)
	    				comments << comment
	    			end
	    			rand(3..5).times do
	    				comment = Comment.create(:user_id => users.sample.id , :message => Faker::Lorem.paragraph(2) , :commentable => bucket)
	    				comments << comment
	    			end

	    			comments.each do |comment|
	    				rand(0..4).times do
	    					CommentResponse.create(:message => Faker::Lorem.paragraph(2) , :user_id => users.sample.id ,:comment_id => comment.id )
	    				end
	    			end



    			end
    		end

    	end


    end
   	users.each do |user| 
   		rand(3..9).times do
    		user.course_favorites << CourseFavorite.create( :user_id => user.id ,  :course_id => courses.sample.id )
    		user.course_enrollments << CourseEnrollment.create( :user_id => user.id ,  :course_id => courses.sample.id )
    		user.uploads << Upload.create( :user_id => user.id ,  :bucket_id => buckets.sample.id )
    		user.downloads << Download.create( :user_id => user.id ,  :bucket_id => buckets.sample.id )
    	end
   	end

  end
end