class College < ActiveRecord::Base
  attr_accessor :branch_id
  has_many :college_branch_pairs
  has_many :branches, through: :college_branch_pairs

  validates :name, :presence => true
<<<<<<< HEAD
  validates :name, :uniqueness => true
=======
  validates :name, :uniqueness => true , :case_sensitive => false
>>>>>>> tempclasscollab/master

  def buckets
  	all_college_branch_pairs = self.college_branch_pairs
  	courses = all_college_branch_pairs.map{|college_branch_pair| college_branch_pair.courses }.flatten
  	bucket_ids = courses.map{|course| course.buckets }.flatten.map(&:id)
    buckets = Bucket.where(:id => bucket_ids)
  	return buckets
  end

  def buckets_by_branch(branch_id)
    college_branch_pair = CollegeBranchPair.where(:college_id => self.id , :branch_id => branch_id).first
    if college_branch_pair
      courses = college_branch_pair.courses rescue nil
      bucket_ids = courses.map{|course| course.buckets }.flatten.map(&:id) rescue nil
      buckets = Bucket.where(:id => bucket_ids)
      return buckets
    else
      return nil
    end
  end


  def courses
  	all_college_branch_pairs = college_branch_pairs.flatten
  	course_ids = all_college_branch_pairs.map{|college_branch_pair| college_branch_pair.courses }.flatten.map(&:id)
    courses = Course.where(:id => course_ids)
    return courses
  end

  def courses_by_branch(branch_id)
    college_branch_pair = CollegeBranchPair.where(:college_id => self.id , :branch_id => branch_id).first
    if college_branch_pair
      course_ids = college_branch_pair.courses.map(&:id)
      courses = Course.where(:id => course_ids)
      return courses
    else
      return nil
    end
  end


  def users
    user_ids = self.college_branch_pairs.map{|college_branch_pair| college_branch_pair.users }.flatten.map(&:id)
    users = User.where(:id => user_ids)
    return users
  end

  def users_by_branch(branch_id)
    college_branch_pair = CollegeBranchPair.where(:college_id => self.id , :branch_id => branch_id).first
    if college_branch_pair
      user_ids = college_branch_pair.users.map(&:id)
      users = User.where(:id => user_ids)
      return users
    else
      return nil
    end
  end


  def comments_by_branch(branch_id)
    college_branch_pair = CollegeBranchPair.where(:college_id => self.id , :branch_id => branch_id).first
    college_branch_pair.comments rescue nil
  end

  def documents
      Document.where( :bucket_id => self.buckets.map(&:id) )
  end


  def data_shared
<<<<<<< HEAD
=======
      courses = self.courses
      size = 0
      for course in courses
          buckets = course.buckets
          for bucket in buckets
            size += bucket.size
          end
      end
      return size
>>>>>>> tempclasscollab/master
  end
  
  ransacker :by_branch_name,
        formatter: proc { |selected_branch_id|
              data = Branch.find_by_id(selected_branch_id).colleges.map(&:id)
              data = data.present? ? data : nil
        } do |parent|
        parent.table[:id]
  end

  ransacker :by_course_name,
        formatter: proc { |selected_course_id|
              data = (Course.search(  Course.find_by_id(selected_course_id).name  ).map{|course|  course.colleges.map(&:id)  }.flatten rescue nil)
              data = data.present? ? data : nil
        } do |parent|
        parent.table[:id]
  end



end


