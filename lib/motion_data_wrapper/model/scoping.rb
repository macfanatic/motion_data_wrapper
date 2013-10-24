module MotionDataWrapper
  class Model < NSManagedObject
    module Scoping
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        # Scopes allow you to store named queries as class methods on your model
        # as well as an instance method on the returned Relation for chainability
        #
        # Examples:
        #   class Task
        #     scope :overdue, ->{ where "date < ?", NSDate.date }
        #   end
        #
        #   Task.overdue => Relation
        #   Task.overdue.count
        #
        #   Task.where("title = ?", "My Task").overdue
        #   Task.overdue.exists?
        #
        def scope(name, proc)
          raise ArgumentError, "'#{name}' must be a Symbol" unless name.is_a?(Symbol)
          raise ArgumentError, "'#{proc}' must be a Proc" unless proc.is_a?(Proc)

          raise ArgumentError, "cannot redefine class method '#{name}'" if respond_to?(name)
          raise ArgumentError, "cannot redefine '#{name}' method on Relation" if Relation.instance_methods.include? name

          define_singleton_method name, &proc
          Relation.send :define_method, name, &proc
        end

        private :scope
      end
    end
  end
end
