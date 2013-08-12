module MotionDataWrapper
  class Model < NSManagedObject
    module Persistence
    
      def self.included(base)
        base.extend(ClassMethods)
      end
 
      module ClassMethods
      
        def create(attributes={})
          begin
            model = create!(attributes)
          rescue MotionDataWrapper::RecordNotSaved
          end
          model
        end

        def create!(attributes={})
          model = new(attributes)
          model.save!
          model
        end
      
        def new(attributes={})
          alloc.initWithEntity(entity_description, insertIntoManagedObjectContext:nil).tap do |model|
            model.instance_variable_set('@new_record', true)
            attributes.each do |keyPath, value|
              model.setValue(value, forKey:keyPath)
            end
          end
        end
      
      end
  
      def awakeFromFetch
        super
        after_fetch if respond_to? :after_fetch
      end

      def awakeFromInsert
        super
        after_fetch if respond_to? :after_fetch
      end
  
      def destroy
      
        if context = managedObjectContext
          before_destroy_callback
          context.deleteObject(self)
          error = Pointer.new(:object)
          if context.save(error)
            @destroyed = true
            after_destroy_callback
            freeze
          end
        end
      
      end
    
      def destroyed?
        @destroyed || false
      end
    
      def new_record?
        @new_record || false
      end
    
      def persisted?
        !(new_record? || destroyed?)
      end
    
      def save
        begin
          save!
        rescue MotionDataWrapper::RecordNotSaved
          return false
        end
        true
      end
    
      def save!        
        unless context = managedObjectContext
          context = App.delegate.managedObjectContext
          context.insertObject(self)
        end

        before_save_callback
        error = Pointer.new(:object)
        unless context.save(error)
          managedObjectContext.deleteObject(self)
          raise MotionDataWrapper::RecordNotSaved, self and return false
        end
        instance_variable_set('@new_record', false)
        after_save_callback

        true
      end
  
      private
  
      def before_save_callback
        before_save if respond_to? :before_save
        @is_new_record = new_record?
        if @is_new_record
          before_create if respond_to? :before_create
        else
          before_update if respond_to? :before_update
        end
      end
  
      def after_save_callback
        if @is_new_record
          after_create if respond_to? :after_create
        else
          after_update if respond_to? :after_update
        end
        after_save if respond_to? :after_save
      end

      def before_destroy_callback
        before_destroy if respond_to? :before_destroy
      end
  
      def after_destroy_callback
        after_destroy if respond_to? :after_destroy
      end
  
    end
  end
end
