require 'webmasters_cms/railtie'
require "webmasters_cms/engine"
require "webmasters_cms/extensions/routing"

module WebmastersCms
  def self.uploaded_by_klass=(klass)
    @uploaded_by_klass = klass
  end

  def self.uploaded_by_klass
    @uploaded_by_klass
  end

  def self.uploaded_by_table_name
    uploaded_by_klass.table_name if uploaded_by_klass
  end

  def self.uploaded_by_validation=(v)
    @uploaded_by_validation = v
  end

  def self.uploaded_by_validation
    @uploaded_by_validation ||= :admin?
  end

  if Rails.env.test?
  def self.uploaded_by_factory_name=(v)
    @uploaded_by_factory_name = v
  end

  def self.uploaded_by_factory_name
    @uploaded_by_factory_name
  end
  end
end

# manual requiring of jquery gems as work-around because it did not work automatically
require 'jquery-rails' unless defined? Jquery::Rails
require 'jquery-ui-rails' unless defined? Jquery::Ui
require 'jquery/mjs/nestedSortable/rails' unless defined? Jquery::Mjs::NestedSortable::Rails::Engine
require 'paperclip' unless defined? Paperclip
require 'paperclip-i18n' unless defined? PaperclipI18n
