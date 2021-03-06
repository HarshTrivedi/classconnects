require "notify_enrolled_waiters"
require "notify_favorited_waiters"

class Bucket < ActiveRecord::Base
  attr_accessor :course_id
  acts_as_votable
  include PgSearch

  pg_search_scope :full_text_search, :against => [:name, :description],
  associated_against: { category: :category , course: [:name] , folders: [:name] , documents: [:name] } ,
  :using => {
        :tsearch => {:prefix => true}
        }
  paginates_per 10

  after_create :store_aws_name

  after_create :notifiy_waiters


  def store_aws_name
      self.aws_name = self.name
      self.save
  end

  def notifiy_waiters
    Resque.enqueue( NotifyEnrolledWaiters , self.uploader.id , self.id )    
    Resque.enqueue( NotifyFavoritedWaiters , self.uploader.id , self.id )    
  end



  belongs_to :category
  belongs_to :course
  belongs_to :user
  has_many :folders , :dependent => :destroy
  has_many :documents , :dependent => :destroy
  # has_many :uploads , :dependent => :destroy
  has_many :downloads , :dependent => :destroy
  has_many :comments, as: :commentable , :dependent => :destroy
  has_many :reported_inappropriates , :dependent => :destroy

  validates :user, :presence => true
  validates :name, :presence => true
  validates :description, :presence => true
  validates :category, :presence => true
  validates :course, :presence => true



  def uploader
    self.user
  end


  def downloaders
    user_ids = self.downloads.map{|download| download.user }.map(&:id)
    User.where(:id => user_ids)
  end

  def up_votes
    votes_for.up.size
  end

  def down_votes
    votes_for.down.size
  end

  def self.search(search)
      if not search.strip.empty?
        full_text_search(search)
      else
        all
      end

  end


  def self.filter_search_for(user)
      publicly_shared_bucket_ids  = where(:privately_shared => false).map(&:id)
      privately_shared_buckets = where(:privately_shared => true)
      
      private_accessible_bucket_ids = []
      
      for private_bucket in privately_shared_buckets
        if private_bucket.college == user.college
          private_accessible_bucket_ids << private_bucket.id
        end
      end

      accessible_bucket_ids = publicly_shared_bucket_ids + private_accessible_bucket_ids

      where(:id => accessible_bucket_ids)

  end

  def data_shared
  end

  def college
      self.course.college
  end

  ransacker :by_college_name,
        formatter: proc { |selected_college_id|
              data = College.find_by_id( selected_college_id ).buckets.map(&:id)
              data = data.present? ? data : nil
        } do |parent|
        parent.table[:id]
  end

  ransacker :by_branch_name,
        formatter: proc { |selected_branch_id|
              data = Branch.find_by_id(  selected_branch_id  ).buckets.map(&:id)
              data = data.present? ? data : nil
        } do |parent|
        parent.table[:id]
  end

  ransacker :by_course_name,
        formatter: proc { |selected_course_id|
              data = Course.find(  selected_course_id  ).buckets.map(&:id)
              data = data.present? ? data : nil
        } do |parent|
        parent.table[:id]
  end

  def download_url
    s3 = AWS::S3.new
    bucket = s3.buckets[ENV["S3_BUCKET"]]
    object = bucket.objects["zip/#{aws_root_to_self_path}.zip"]
    object.url_for(:get, { 
      expires: 10.minutes,
      response_content_disposition: 'attachment;'
    }).to_s
  end


  def aws_root_to_self_path
    "bucket_id_#{self.id}/#{self.aws_name}"
  end

  def size
      size = 0
      self.folders.each{|folder| size += folder.size }
      self.documents.each{|document| size += document.size }
      return size
  end


end
