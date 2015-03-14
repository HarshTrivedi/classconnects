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


end
