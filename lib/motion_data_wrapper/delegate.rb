module MotionDataWrapper
  module Delegate

    def managedObjectContext
      @managedObjectContext ||= begin
        documentsDirectory = NSFileManager.defaultManager.URLsForDirectory(NSDocumentDirectory, inDomains:NSUserDomainMask).lastObject;
        storeURL = documentsDirectory.URLByAppendingPathComponent("#{sqlite_store_name}.sqlite")

        error_ptr = Pointer.new(:object)
        unless persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration:nil, URL:storeURL, options:persistent_store_options, error:error_ptr)
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
      NSBundle.mainBundle.infoDictionary.objectForKey("CFBundleName")
    end

    def persistent_store_options
      { NSMigratePersistentStoresAutomaticallyOption => true, NSInferMappingModelAutomaticallyOption => true }
    end

  end
end
