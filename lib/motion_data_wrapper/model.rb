module MotionDataWrapper
  class Model < NSManagedObject
    include CoreData
    include FinderMethods
    include Persistence
    include Validations

    def inspect
      properties = []
      entity.properties.select { |p| p.is_a?(NSAttributeDescription) }.each do |property|
        properties << "#{property.name}: #{valueForKey(property.name).inspect}"
      end

      "#<#{entity.name} #{properties.join(", ")}>"
    end

  end
end
