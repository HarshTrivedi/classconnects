class Folder < ActiveRecord::Base
  attr_accessor :folder_id , :bucket_id
  has_ancestry :orphan_strategy => :destroy
  paginates_per 10

  belongs_to :bucket , :touch => true
  has_many :documents  

  belongs_to :folder
  has_many :folders #, -> { order("position ASC") }
  # acts_as_list scope: :folder

  has_many :folders , :dependent => :destroy
  has_many :documents  , :dependent => :destroy

  validates :name, :presence => true
  validates :bucket, :presence => true

  def self.search(search)
      if not search.strip.empty?
        where('name LIKE ?', "%#{search}%")
      else
        all
      end
  end


  def bread_crumb_paths
    bucket_id = self.bucket.id
    self.path_ids.map{|folder_id| [ Folder.find_by_id(folder_id).name , "/admin/buckets/#{bucket_id}/folders/#{folder_id}" ]}
  end

  def student_bread_crumb_paths
    bucket_id = self.bucket.id
    self.path_ids.map{|folder_id| [ Folder.find_by_id(folder_id).name , "/folders/#{folder_id}/content" ]}
  end


  def link
    "/admin/buckets/#{self.bucket.id}/folders/#{id}"
  end

  def link_tag
    "<a href='" + self.link + "'>" + self.name + "</a>"
  end
  
  def self.convert_hash_keys(value)
    case value
      when Array
        value.map { |v| convert_hash_keys(v) }
      when Hash
        Hash[value.map { |k, v| [ k.link_tag, convert_hash_keys(v)] }]
      else
        value
     end
  end

  def self.hash_to_html(hash, opts = {})
    return if !hash.is_a?(Hash)
    indent_level = opts.fetch(:indent_level) { 0 }
    out = " " * indent_level + "<ul>\n"
    hash.each do |key, value|
      out += " " * (indent_level + 2) + "<li><strong>#{key}:</strong>"
      if value.is_a?(Hash)
        out += "\n" + hash_to_html(value, :indent_level => indent_level + 2) + " " * (indent_level + 2) + "</li>\n"
      else
        out += " <span>#{value}</span></li>\n"
      end
    end
    out += " " * indent_level + "</ul>\n"
  end



  def subtree_html    
    Folder.hash_to_html(  Folder.convert_hash_keys( self.subtree.arrange.to_hash) )
  end

  def aws_root_to_self_path
    bucket = Bucket.find_by_id(self.bucket.id)
    folder_path = self.path_ids.map{ |folder_id| "#{Folder.find_by_id(folder_id).name}"  }.join("/")
    return "bucket_id_#{bucket.id}/#{bucket.name}/#{folder_path}".chop
  end

end

