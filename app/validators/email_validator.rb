class EmailValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value =~ /[^@]+@[^\.]+\.[^\.]+/
      record.errors[attribute] << (options[:message] || 'emails should be in the format username@example.com')
    end
  end

end
