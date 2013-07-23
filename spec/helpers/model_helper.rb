module MotionDataWrapper
  module Delegate
    def clean_data
      @managedObjectContext = nil
      @managedObjectModel = nil
      @coordinator = nil
      manager = NSFileManager.defaultManager
      manager.removeItemAtURL sqlite_url, error:nil if manager.fileExistsAtPath sqlite_url.path
    end
  end
end

module MotionDataWrapper
  class Model
    module CoreData
  
      module ClassMethods
    
        def clean_entity_description
          @_metadata = nil
        end

      end
  
    end
  end
end

def clean_core_data
  App.delegate.clean_data
  Task.clean_entity_description
end