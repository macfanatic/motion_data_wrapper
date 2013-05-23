module MotionDataWrapper
  class RecordInvalid < StandardError
  
    def initialize(record)
      @record = record
      @errors = @record.errors
      super(@errors.map { |k,v| "#{k} #{v}"}.join(', '))
    end
  
  end
end
