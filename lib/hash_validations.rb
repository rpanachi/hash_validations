require File.expand_path(File.dirname(__FILE__) + "/validatable/validatable")

module Validatable

  def self.included(klass) #:nodoc:
    #ignore
  end

  def valid_for_group?(group) #:nodoc:
    run_before_validations
    errors.clear
    self.validate_children(self, group)
    self.validate(group)
    errors.empty?
  end
  
  # call-seq: validate_only(key)
  #
  # Only executes a specified validation. The argument should follow a pattern based on the key of the validation.
  #   Examples:
  #     * validates_presence_of :name can be run with obj.validate_only("presence_of/name")
  #     * validates_presence_of :birthday, :key => "a key" can be run with obj.validate_only("presence_of/a key")
  def validate_only(key)
    validation_name, attribute_name = key.split("/")
    validation_name = validation_name.split("_").collect{|word| word.capitalize}.join
    validation_key = "#{self.name}/Validatable::Validates#{validation_name}/#{attribute_name}"
    validation = self.all_validations.find { |validation| validation.key == validation_key }
    raise ArgumentError.new("validation with key #{validation_key} could not be found") if validation.nil?
    errors.clear
    run_validation(validation)
  end

  protected
  def run_validation(validation) #:nodoc:
    validation_result = validation.valid?(self)
    add_error(self, validation.attribute, validation.message(self)) unless validation_result
    increment_times_validated_for(validation)
    validation.run_after_validate(validation_result, self, validation.attribute)
  end

  def run_before_validations #:nodoc:
    self.all_before_validations.each do |block|
      instance_eval &block
    end
  end
  
  def all_validations #:nodoc:
    res = self.validations_to_include.inject(self.all_validations) do |result, included_validation_class|
      result += self.send(included_validation_class.attribute).all_validations
      result
    end
  end
  
  def validation_levels #:nodoc:
    self.all_validations.inject([1]) { |result, validation| result << validation.level }.uniq.sort
  end

  class Errors

    def has_key?(key)
      @errors.has_key?(key)
    end

    def humanize(lower_case_and_underscored_word) #:nodoc:
      ":#{lower_case_and_underscored_word}"
    end

  end

end

class Hash

  include Validatable
  include Validatable::ClassMethods
  include Validatable::Macros

  attr_accessor :name
  attr_accessor :superclass

  def method_missing(method_name, *args)
    self[method_name]
  end

end





