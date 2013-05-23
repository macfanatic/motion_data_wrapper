module MotionDataWrapper
  class Relation < NSFetchRequest
    include CoreData
    include FinderMethods

    def initWithClass(klass)
      self.entity = klass.entity_description if init
      self
    end

  end
end
