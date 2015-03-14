class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook]

  #->Prelang (user_login/devise)
  has_many :comments
  has_many :course_enrollments
  has_many :uploads
  has_many :course_favorites
  has_many :downloads
  belongs_to :college_branch_pair
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
      bucket_ids = uploads.map{|upload| upload.bucket }.map(&:id)
      Bucket.where(:id => bucket_ids)
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


end
