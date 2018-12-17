class WebmastersCms::File < WebmastersCms::ApplicationRecord

  klass = WebmastersCms.uploaded_by_klass
  belongs_to :uploaded_by, :class_name => klass.to_s if klass
  
  has_attached_file :file
 
  validates :uploaded_by_id, :presence => true if klass
  validate :validates_uploaded_by_is_authorized if klass

  validates_attachment :file, :presence => true,
    :content_type => {:content_type => [/\A(image|video)\/.*\Z/, 'application/pdf']}
  
  before_file_post_process :rename_file

  private
  def validates_uploaded_by_is_authorized
    cond = uploaded_by_id_changed? && uploaded_by &&
      !uploaded_by.public_send(WebmastersCms.uploaded_by_validation)

    errors.add :uploaded_by_id, :is_not_authorized if cond
  end

  def rename_file
    ext = File.extname file.original_filename
    name = file.original_filename.split('.')[0..-2].join('.').parameterize + ext
    file.instance_write :file_name, name
  end
end
