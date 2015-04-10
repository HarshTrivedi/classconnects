class User < ActiveRecord::Base
  paginates_per 1
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook]

  acts_as_voter

  #->Prelang (user_login/devise)
  has_many :comments
  has_many :course_enrollments
  # has_many :uploads
  has_many :buckets
  has_many :course_favorites
  has_many :downloads
  belongs_to :college_branch_pair



  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true

  scope :all_admins,        ->{ User.where(  :id =>  User.all.select{|user| user.is_admin? }.map(&:id)                      )}
  scope :content_generator, ->{ User.where(  :id =>  User.all.select{|user| user.role?(:content_generator)    }.map(&:id)   )}
  scope :content_moderator, ->{ User.where(  :id =>  User.all.select{|user| user.role?(:content_moderator)    }.map(&:id)   )}
  scope :college_generator, ->{ User.where(  :id =>  User.all.select{|user| user.role?(:college_generator)    }.map(&:id)   )}
  scope :non_admins,        ->{ User.where(  :id =>  User.all.select{|user| user.role?(:non_admins)  }.map(&:id)            )}

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first

    # The User was found in our database
    return user if user

    # Check if the User is already registered without Facebook
    user = User.where(email: auth.info.email).first

    return user if user

    # The User was not found and we need to create them
    User.create(name:     auth.extra.raw_info.name,
                provider: auth.provider,
                uid:      auth.uid,
                email:    auth.info.email,
                password: Devise.friendly_token[0,20])
  end

  def enrolled_courses
      course_ids = self.course_enrollments.map{|course_enrollment| course_enrollment.course }.map(&:id)
      Course.where(:id => course_ids)
  end


  def favorite_courses
      course_ids = self.course_favorites.map{|course_favorite| course_favorite.course }.flatten.map(&:id)
      Course.where(:id => course_ids)
  end


  def downloaded_buckets
      bucket_ids = downloads.map{|download| download.bucket }.map(&:id)
      Bucket.where(:id => bucket_ids)
  end


  def uploaded_buckets
      # bucket_ids = uploads.map{|upload| upload.bucket }.map(&:id)
      # Bucket.where(:id => bucket_ids)
      self.buckets
  end

  def college
      self.college_branch_pair.college rescue nil
  end

  def branch
      self.college_branch_pair.branch rescue nil
  end

  def college_branch_enrolled?
      not (college.nil? or branch.nil?)
  end

  def private_buckets
    return Bucket.none if college.nil?
    all_college_branch_pairs = college.college_branch_pairs.flatten
    courses = all_college_branch_pairs.map{|college_branch_pair| college_branch_pair.courses }.flatten
    bucket_ids = courses.map{|course| course.buckets }.flatten.map(&:id)
    buckets = Bucket.where(id: bucket_ids)
    return buckets
  end

  def public_buckets
    return Bucket.all if college.nil?
    all_college_branch_pairs = college.college_branch_pairs.flatten
    courses = all_college_branch_pairs.map{|college_branch_pair| college_branch_pair.courses }.flatten
    bucket_ids = courses.map{|course| course.buckets }.flatten.map(&:id)
    buckets = Bucket.where.not(:id => bucket_ids)
    return buckets
  end

  def enroll_college_branch_pair(college_id , branch_id)
    college_branch_pair = CollegeBranchPair.where(:college_id => college_id , :branch_id => branch_id).first
    if college_branch_pair
        college_branch_pair.users << self
        return college_branch_pair
    end
    return nil
  end

  def college_peers
    college = self.college
    if not college.nil?
      college_users = college.users
      college_peers = college_users - self
      college_peers
    else
      return nil 
    end
  end


  # If user is not enrolled in the course, it will return NIL
  # And [] , when he is the only one who has enrolled in that course
  def course_peers(course_id)
    user_is_enrolled = CourseEnrollment.exists(:user_id => self.id , :course_id => course_id)
    if user_is_enrolled
      course = Course.find_by_id(course_id)
      course_enrolled_users = course.enrolled_users
      course_peers = course_enrolled_users - self
      return course_peers
    else
      return nil
    end
  end

  def comment_on(object , message )
      if object.is_a?(Bucket) or object.is_a?(Course) or object.is_a?(CollegeBranchPair)
        comment = Comment.create(:user_id => self.id , :message => message , :commentable => object)
        return comment
      else
        return nil
      end
  end

  def respond_to_comment(comment_id , message )
      if Comment.exists?(comment_id)
        comment_response = CommentResponse.create(:message => message , :user_id => self.id ,:comment_id => comment_id )
        return comment_response
      else
        return nil
      end
  end


  def upload_bucket(bucket_id)
      bucket = Bucket.where(:id => bucket_id ).first
      if bucket
        self.buckets << bucket
      end
      return bucket
  end

  def download_bucket(bucket_id)
      if Bucket.exists?(:id => bucket_id)
        download = Download.create( :user_id => id ,  :bucket_id => bucket_id )
        bucket = download.bucket
      else
        bucket = nil
      end
      return bucket
  end

  def favorite_course(course_id)
      if Course.exists?(:id => course_id)
        favorite = CourseFavorite.create( :user_id => id ,  :course_id => course_id )
        course = favorite.course
      else
        course = nil
      end
      return course
  end

  def unfavorite_course(course_id)    
    CourseFavorite.delete_all( :user_id => id , :course_id => course_id)
  end


  def enroll_course(course_id)
      if Course.exists?(:id => course_id)
        enrollment = CourseEnrollment.create( :user_id => id ,  :course_id => course_id )
        course = enrollment.course
      else
        course = nil
      end
      return course
  end

  def unenroll_course(course_id)
    CourseEnrollment.delete_all( :user_id => id , :course_id => course_id)
  end

  def full_name
    [self.first_name , self.last_name ].join(" ")
  end

  def can_upload?(object)
    if object.is_a?(Bucket)
        self == object.uploader
    else
        self == object.bucket.uploader
    end
  end


  def reputation
    #Take Upvotes a score of 10 and Downvotes a score of -1 and add them up
    #Inefficient implementation... will need to change it afterwards.
    self.uploaded_buckets.map{|bucket| 10 * bucket.up_votes - bucket.down_votes}.inject{|sum , i| sum += i}
  end

  def self.search(search)
      if not search.strip.empty?
        where('email LIKE ?', "%#{search}%")
      else
        all
      end
  end

  def role?(r)
      role.include? r.to_s rescue false
  end

  def is_admin?
      role?(:super_admin) or role?(:content_generator) or role?(:content_moderator) or role?(:college_generator)
  end

  def authorized_to?(action , object)
    Ability.new( self ).can?( action , object )
  end

end
