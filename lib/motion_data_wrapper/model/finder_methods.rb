module MotionDataWrapper
  class Model < NSManagedObject
    module FinderMethods

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        # Delegate the simplest methods to the relation without any args
        %w(all count destroy_all empty? exists? uniq).each do |method|
          define_method method do
            relation.send(method)
          end
        end

        # @param [Symbol] query part to exclude, ie :where or :limit
        # @returns [Relation]
        def except(query_part)
          relation.except(query_part)
        end

        # @returns [Model] or nil
        def first
          relation.first
        end

        # @param [id] id to retrieve record by
        # @raises [RecordNotFound]
        # @returns [Model]
        def find(object_id)
          find_by_id!(object_id)
        end

        # @returns [Model] or nil
        def last
          relation.last
        end

        # @param [Fixnum]
        # @returns [Relation]
        def limit(l)
          relation.limit(l)
        end

        # @param [Fixnum]
        # @returns [Relation]
        def offset(o)
          relation.offset(o)
        end

        # @param [Symbol] column
        # @param @optional [Hash] options, key :ascending
        # @returns [Relation]
        def order(*args)
          relation.order(*args)
        end

        # @param [Symbol] column
        # @returns [Array]
        def pluck(column)
          relation.pluck(column)
        end

        def respond_to?(method)
          if method.start_with?("find_by_") || method.start_with?("find_all_by_")
            true
          else
            super
          end
        end

        # @param [String] conditions
        # @param [vargs] Replacements
        # @returns [Relation]
        # Usage:
        #   where("title contains[cd] ?", "title")
        def where(*args)
          relation.where(*args)
        end

        # @param [NSManagedObjectContext]
        # @param [Relation]
        def with_context(ctx)
          relation.with_context(ctx)
        end

        private

        def method_missing(method, *args, &block)
          if method.start_with?("find_by_")
            attribute = method.gsub("find_by_", "").gsub("!", "")
            chain = relation.where("#{attribute} = ?", *args)

            if method.end_with?("!")
              chain.first!
            else
              chain.first
            end

          elsif method.start_with?("find_all_by_")
            attribute = method.gsub("find_all_by_", "")
            relation.where("#{attribute} = ?", *args).to_a

          else
            super
          end
        end

        def relation
          Relation.alloc.initWithClass(self)
        end

      end

    end

  end
end
