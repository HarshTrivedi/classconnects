class Document < ActiveRecord::Base
<<<<<<< HEAD
  paginates_per 3
=======
  paginates_per 10
>>>>>>> tempclasscollab/master
  belongs_to :folder
  belongs_to :bucket, :touch => true

  validates :bucket, :presence => true 
  validates :name, :presence => true
  # validates :cloud_path, :presence => true

<<<<<<< HEAD
  def self.search(search)
      if not search.strip.empty?
        where('name LIKE ?', "%#{search}%")
=======
  after_create :store_aws_name

  def store_aws_name
      self.aws_name = self.name
      self.save
  end


  def self.search(search)
      if not search.strip.empty?
        where('name ILIKE ?', "%#{search}%")
>>>>>>> tempclasscollab/master
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
<<<<<<< HEAD
    s3 = AWS::S3.new
    bucket = s3.buckets[ENV["S3_BUCKET"]]
    object = bucket.objects[self.cloud_path]
    object.url_for(:get, { 
      expires: 10.minutes,
      response_content_disposition: 'attachment;'
    }).to_s
=======
      s3 = AWS::S3.new
      bucket = s3.buckets[ENV["S3_BUCKET"]]
      object = bucket.objects[self.aws_root_to_self_path]
      object.url_for(:get, { 
        expires: 10.minutes,
        response_content_disposition: 'attachment;'
      }).to_s
>>>>>>> tempclasscollab/master
  end

  def aws_root_to_self_path
    bucket = Bucket.find_by_id(self.bucket.id)
    folder = self.folder
<<<<<<< HEAD
    bucket_path = "#{bucket.name}/"
    if folder
        folder_path = folder.path_ids.map{ |folder_id| "#{Folder.find_by_id(folder_id).name}"  }.join("/")
        return "bucket_id_#{bucket.id}/#{bucket.name}/#{folder_path}/#{self.name}"
    else
        return "bucket_id_#{bucket.id}/#{bucket.name}/#{self.name}"
=======
    bucket_path = "#{bucket.aws_name}/"
    if folder
        folder_path = folder.path_ids.map{ |folder_id| "#{Folder.find_by_id(folder_id).aws_name}"  }.join("/")
        return "bucket_id_#{bucket.id}/#{bucket.aws_name}/#{folder_path}/#{self.aws_name}"
    else
        return "bucket_id_#{bucket.id}/#{bucket.aws_name}/#{self.aws_name}"
>>>>>>> tempclasscollab/master
    end

  end


<<<<<<< HEAD
=======
  def image_url
    filetype = self.s3["filetype"] rescue ""

    if filetype.start_with?("text") 
        return "document_text.png"
    elsif filetype == "application/pdf"
        return "document_pdf.png"
    elsif filetype == "image/jpeg"
        return "document_jpg.png"
    elsif filetype == "image/png"
        return "document_png.png"      
    elsif filetype == "image/gif"
        return "document_gif.png"      
    elsif filetype == "application/zip"
        return "document_zip.png"            
    elsif filetype == "application/x-rar"
        return "document_rar.png"                  
    else
        return "document_default.png"
    end

  end

  def size
      self.s3["filesize"].to_i rescue 0
  end

  def type
      document[:s3]["filetype"]  rescue "none"
  end


>>>>>>> tempclasscollab/master
end
