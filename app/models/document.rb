class Document < ActiveRecord::Base
  paginates_per 3
  belongs_to :folder
  belongs_to :bucket, :touch => true

  validates :bucket, :presence => true 
  validates :name, :presence => true
  # validates :cloud_path, :presence => true

  def self.search(search)
      if not search.strip.empty?
        where('name LIKE ?', "%#{search}%")
      else
        all
      end
  end


  ransacker :by_college_name,
        formatter: proc { |selected_college_id|
              data = College.find_by_id( selected_college_id ).documents.map(&:id)
              data = data.present? ? data : nil
        } do |parent|
        parent.table[:id]
  end

  ransacker :by_branch_name,
        formatter: proc { |selected_branch_id|
              data = Branch.find_by_id(  selected_branch_id  ).documents.map(&:id)
              data = data.present? ? data : nil
        } do |parent|
        parent.table[:id]
  end

  ransacker :by_course_name,
        formatter: proc { |selected_course_id|
              data = Course.find(  selected_course_id  ).documents.map(&:id)
              data = data.present? ? data : nil
        } do |parent|
        parent.table[:id]
  end

  # def parent
  #   self.folder
  # end

  def download_url
    s3 = AWS::S3.new
    bucket = s3.buckets[ENV["S3_BUCKET"]]
    object = bucket.objects[self.cloud_path]
    object.url_for(:get, { 
      expires: 10.minutes,
      response_content_disposition: 'attachment;'
    }).to_s
  end

  def aws_root_to_self_path
    bucket = Bucket.find_by_id(self.bucket.id)
    folder = self.folder
    bucket_path = "#{bucket.name}/"
    if folder
        folder_path = folder.path_ids.map{ |folder_id| "#{Folder.find_by_id(folder_id).name}"  }.join("/")
        return "bucket_id_#{bucket.id}/#{bucket.name}/#{folder_path}/#{self.name}"
    else
        return "bucket_id_#{bucket.id}/#{bucket.name}/#{self.name}"
    end

  end


  def image_url
    filetype = self.s3["filetype"] rescue ""

    if filetype.start_with?("text") 
        return "/assets/text_document.jpg"
    elsif filetype == "application/pdf"
        return "/assets/pdf_document.jpg"
    elsif filetype == "XXXimage"
        return "/assets/image_document.jpg"
    elsif filetype == "XXXword"
        return "/assets/word_document.jpg"      
    elsif filetype == "XXXppt"
        return "/assets/ppt_document.jpg"      
    else
        return "/assets/default_document.jpg"
    end

  end

  def size
      self.s3["filesize"].to_i rescue 0
  end

end
