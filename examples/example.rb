require "../lib/hash_validations"

class MyClass

  def initialize(attributes = {})

    parameters = {}.merge(attributes)
    parameters.validates_presence_of :teste, :outro

    raise ArgumentError.new(parameters.errors.full_messages.join(", ")) unless parameters.valid?

  end

end
