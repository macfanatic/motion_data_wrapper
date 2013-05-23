module MotionDataWrapper
  class RecordNotFound < StandardError
  
    def initialize(klass, id)
      @klass = klass
      @id = id
      super("Could not find #{@klass.name} id: #{@id}")
    end
  
  end
end
