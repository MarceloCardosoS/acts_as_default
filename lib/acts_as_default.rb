require_relative 'acts_as_default/version'
require 'active_support/concern'

module ActsAsDefault

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    attr :field_key

    def acts_as_default(field = nil)
      @field_key = field
      include ActsAsDefault::InstanceMethods
    end
  end

  module InstanceMethods
    extend ActiveSupport::Concern

    included do
      before_save :check_before_save
      after_destroy :check_after_destroy
    end

    def set_as_default!
      if default == false
        get_default_object.toggle!(:default)
        toggle!(:default)
      end
    end

    private

    def check_before_save
      if self.default
        obj = get_default_object
        obj.toggle!(:default) if obj and obj.id != id
      else
        self.default = check_if_empty?
      end
      return true
    end

    def check_after_destroy
      obj = get_default_object
      if obj.nil?
        obj = get_collection.order(created_at: :desc).first
        obj.toggle!(:default) if obj
      end
    end

    def check_if_empty?
      get_collection.size == 0
    end

    def get_collection
      if self.class.field_key.nil?
        self.class.all
      else
        self.class.where(self.class.field_key => self[self.class.field_key])
      end
    end

    def get_default_object
      if self.class.field_key.nil?
        self.class.where(default: true).first
      else
        key = self.class.field_key
        self.class.where("#{key} = :key and default = :default", {key: self[key], default: 'true'}).first
      end
    end
  end
end