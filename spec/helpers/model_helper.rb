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

def clean_core_data
  App.delegate.clean_data
end