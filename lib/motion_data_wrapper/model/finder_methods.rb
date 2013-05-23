module MotionDataWrapper
  class Model < NSManagedObject
    module FinderMethods
    
      def self.included(base)
        base.extend(ClassMethods)
      end
    
      module ClassMethods
      
        def all
          relation.to_a
        end
      
        def count
          relation.count
        end
        
        def destroy_all
          all.map &:destroy
        end
      
        def except(query_part)
          relation.except(query_part)
        end
      
        def find(object_id)
          raise MotionDataWrapper::RecordNotFound.new(self, object_id) unless entity = find_by_id(object_id)
          entity
        end
      
        def first
          relation.first
        end
      
        def first!
          first or raise MotionDataWrapper::RecordNotFound
        end

        def last
          relation.last
        end

        def last!
          last or raise MotionDataWrapper::RecordNotFound
        end
      
        def limit(l)
          relation.limit(l)
        end
      
        def method_missing(method, *args, &block)
          if method.start_with?("find_by_")
            attribute = method.gsub("find_by_", "")
            relation.where("#{attribute} = ?", *args).first
          elsif method.start_with?("find_all_by_")
            attribute = method.gsub("find_all_by_", "")
            relation.where("#{attribute} = ?", *args).to_a
          else
            super
          end
        end
      
        def offset(o)
          relation.offset(o)
        end

        def order(*args)
          relation.order(*args)
        end
      
        def pluck(column)
          relation.pluck(column)
        end
        
        def reorder(*args)
          relation.except(:order).order(*args)
        end
      
        def respond_to?(method)
          if method.start_with?("find_by_") || method.start_with?("find_all_by_")
            true
          else
            super
          end
        end
      
        def uniq
          relation.uniq
        end

        def where(*args)
          relation.where(*args)
        end
      
      private
      
        def relation
          Relation.alloc.initWithClass(self)
        end
      
      end 
    
    end
    
  end
end
