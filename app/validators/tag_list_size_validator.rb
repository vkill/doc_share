class TagListSizeValidator < ActiveModel::EachValidator

  MESSAGES = { :is => :tag_list_wrong_size, :maximum => :tag_list_size_too_much,
               :minimum => :tag_list_size_too_less }.freeze
  CHECKS = { :is => :==, :minimum => :>=, :maximum => :<= }.freeze

  RESERVED_OPTIONS = [:minimum, :maximum, :within, :is, :tokenizer, :too_short, :too_long]

  def initialize(options)
    if range = (options.delete(:in) || options.delete(:within))
      raise ArgumentError, ":in and :within must be a Range" unless range.is_a?(Range)
      options[:minimum], options[:maximum] = range.begin, range.end
      options[:maximum] -= 1 if range.exclude_end?
    end

    super
  end

  def check_validity!
    keys = CHECKS.keys & options.keys
    if keys.empty?
      raise ArgumentError, 'Range unspecified. Specify the :within, :maximum, :minimum, or :is option.'
    end
    keys.each do |key|
      value = options[key]
      unless value.is_a?(Integer) && value >= 0
        raise ArgumentError, ":#{key} must be a nonnegative Integer"
      end
    end
  end

  def validate_each(record, attribute, value)

    raise(ArgumentError, "A Array was expected") unless value.kind_of?(Array)

    CHECKS.each do |key, validity_check|

      next unless options[key]
   
      check_value = options[key]

      value_size = value.size
      next if value_size.send(validity_check, check_value)

      errors_options = options.except(*RESERVED_OPTIONS)
      errors_options[:tag_list_size] = value_size

      default_message = options[MESSAGES[key]]
      errors_options[:message] ||= default_message if default_message
    
      record.errors.add(attribute, MESSAGES[key], errors_options)
    end
  end

end