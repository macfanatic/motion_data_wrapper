module MotionDataWrapper
  class Relation < NSFetchRequest
    module CoreData

      def inspect
         to_a
       end

      def to_a
        error_ptr = Pointer.new(:object)
        context.executeFetchRequest(self, error:error_ptr)
      end

      private

      def context
        @ctx || App.delegate.managedObjectContext
      end
    end
  end
end
