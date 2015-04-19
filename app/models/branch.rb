class Branch < ActiveRecord::Base
  attr_accessor :college_id
  has_many :college_branch_pairs
  has_many :colleges, through: :college_branch_pairs

  validates :name, :presence => true
  validates :name, :uniqueness => true , :case_sensitive => false

  def buckets
  	all_college_branch_pairs = self.college_branch_pairs
  	courses = all_college_branch_pairs.map{|college_branch_pair| college_branch_pair.courses }.flatten
  	bucket_ids = courses.map{|course| course.buckets }.flatten.map(&:id)
    buckets = Bucket.where(:id => bucket_ids)
  	return buckets
  end

  def documents
      Document.where( :bucket_id => self.buckets.map(&:id) )
  end

  def courses
    all_college_branch_pairs = college_branch_pairs.flatten
    course_ids = all_college_branch_pairs.map{|college_branch_pair| college_branch_pair.courses }.flatten.map(&:id)
    courses = Course.where(:id => course_ids)
    return courses
  end

  def data_shared
      courses = self.courses
      buckets = []
      size = 0
      for course in courses
          buckets = course.buckets
          for bucket in buckets
            size += bucket.size
          end
      end
      return size
  end


  ransacker :by_college_name,
        formatter: proc { |selected_college_id|
              data = College.find_by_id(selected_college_id).branches.map(&:id)
              data = data.present? ? data : nil
        } do |parent|
        parent.table[:id]
  end

  ransacker :by_course_name,
        formatter: proc { |selected_course_id|
              data = (Course.search(  Course.find_by_id(selected_course_id).name  ).map{|course|  course.branches.map(&:id)  }.flatten rescue nil)
              data = data.present? ? data : nil
        } do |parent|
        parent.table[:id]
  end


end
