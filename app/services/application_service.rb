class ApplicationService
  def self.call(...)
    new(...).call
  end

  def call
    raise NotImplementedError, "#{self.class}#call must be implemented"
  end
end
