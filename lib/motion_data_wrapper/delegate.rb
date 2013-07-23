module MotionDataWrapper
  module Delegate

    def managedObjectContext
      @managedObjectContext ||= begin
        error_ptr = Pointer.new(:object)
        unless persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: sqlite_url, options: persistent_store_options, error: error_ptr)
          raise "Can't add persistent SQLite store: #{error_ptr[0].description}"
        end

        context = NSManagedObjectContext.alloc.init
        context.persistentStoreCoordinator = persistentStoreCoordinator

        context
      end
    end

    def managedObjectModel
      @managedObjectModel ||= begin
        model = NSManagedObjectModel.mergedModelFromBundles([NSBundle.mainBundle]).mutableCopy

        model.entities.each do |entity|
          begin
            Kernel.const_get(entity.name)
            entity.setManagedObjectClassName(entity.name)

          rescue NameError
            entity.setManagedObjectClassName("Model")
          end
        end

        model
      end
    end

    def persistentStoreCoordinator
      @coordinator ||= NSPersistentStoreCoordinator.alloc.initWithManagedObjectModel(managedObjectModel)
    end

    def sqlite_store_name
      App.name
    end

    def sqlite_url
      if Object.const_defined?("UIApplication")
        NSURL.fileURLWithPath(sqlite_path)
      else
        error_ptr = Pointer.new(:object)
        unless support_dir = NSFileManager.defaultManager.URLForDirectory(NSApplicationSupportDirectory, inDomain: NSUserDomainMask, appropriateForURL: nil, create: true, error: error_ptr)
          raise "error creating application support folder: #{error_ptr[0]}"
        end
        support_dir = support_dir.URLByAppendingPathComponent("/#{App.name}")
        Dir.mkdir(support_dir.path) unless Dir.exists?(support_dir.path)
        support_dir.URLByAppendingPathComponent("#{sqlite_store_name}.sqlite")
      end
    end
    
    def sqlite_path
      @sqlite_path || File.join(App.documents_path, "#{sqlite_store_name}.sqlite")
    end
    
    def sqlite_path= path
      @sqlite_path = path
    end

    def persistent_store_options
      { NSMigratePersistentStoresAutomaticallyOption => true, NSInferMappingModelAutomaticallyOption => true }
    end

  end
end
