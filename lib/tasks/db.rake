namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'faker'
    require 'awesome_print'
    all_models = ActiveRecord::Base.send(:subclasses)
    all_models.delete(AdminUser)

    all_models.each(&:delete_all)

    colleges = []
    courses  = []
    buckets  = []
    folders  = []
    documents = []
    branches = []
    categories = []
    users = []
    comments = []
    
    rand(10..15).times do
        college = College.create(:name => Faker::Company.name)
        colleges << college
    end
    rand(5..8).times do     
        branch = Branch.create(:name => Faker::Commerce.department)
        branches << branch
    end

    categories << Category.create(:category => "Lecture Slided")
    categories << Category.create(:category => "Exam paper")
    categories << Category.create(:category => "Important")
    categories << Category.create(:category => "collection")
    categories << Category.create(:category => "others")

    rand(15..30).times do
    	user = User.create!({:email => Faker::Internet.email , :password => "harshtrivedi", :password_confirmation => "harshtrivedi" })
    	users << user
    end
    ap users
    for college in colleges
        rand(3..4).times do
            branch = branches.sample
            college.branches << branch
        end
    end
    college_branch_pairs = CollegeBranchPair.all
    ap college_branch_pairs
    for user in users 
        college_branch_pair = college_branch_pairs.sample
        user.enroll_college_branch_pair(college_branch_pair.college_id , college_branch_pair.branch_id)
    end

    for college_branch_pair in college_branch_pairs
        rand(7..10).times do
            course = Course.create(:name => Faker::Lorem.word  , :code => Faker::Code.isbn , :professors => [Faker::Name.name , Faker::Name.name , Faker::Name.name ])
            courses << course
            college_branch_pair.courses << course
        end
        rand(0..5).times do
            comment = User.all.sample.comment_on( college_branch_pair ,  Faker::Lorem.paragraph(2) )
            comments << comment
        end
    end

    for course in courses
        rand(2..10).times do
            bucket = Bucket.create(:description => Faker::Lorem.sentence , :name => Faker::Commerce.product_name )
            bucket.category = categories.sample
            bucket.save
            course.buckets << bucket
            buckets << bucket
        end
        rand(0..8).times do
            comment = User.all.sample.comment_on( course ,  Faker::Lorem.paragraph(2) )
            comments << comment
        end
    end
    ap courses
    for bucket in buckets
        rand(0..7).times do
            folder = Folder.create(:name => Faker::Lorem.word)
            bucket.folders << folder
            folders << folder
        end
        rand(0..8).times do
            document = Document.create(:cloud_path => Faker::Internet.url )
            bucket.documents << document
            documents << document
        end
        rand(0..10).times do
            comment = User.all.sample.comment_on(bucket ,  Faker::Lorem.paragraph(2) )
            comments << comment
        end
    end
    ap folders
    for folder in folders
        rand(0..10).times do
            document = Document.create(:cloud_path => Faker::Internet.url )
            folder.documents << document
            documents << document
        end
    end

    for comment in comments
        User.all.sample.respond_to_comment(comment.id , Faker::Lorem.paragraph(1))
    end
    ap comments


    for user in users
            rand(3..10).times do
                user.upload_bucket(buckets.sample.id)
            end
            rand(3..10).times do
                user.download_bucket(buckets.sample.id)
            end
            rand(3..10).times do
                user.enroll_course(courses.sample.id)
            end
            rand(3..10).times do
                user.favorite_course(courses.sample.id)
            end
    end

  end
end