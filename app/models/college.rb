class College < ActiveRecord::Base
  has_many :college_branch_pairs
  has_many :branches, through: :college_branch_pairs

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





end
