module MotionDataWrapper
  class Model < NSManagedObject
    module Validations
    
      def valid?
        error_ptr = Pointer.new(:object)
        v = new_record? ? validateForInsert(error_ptr) : validateForUpdate(error_ptr)
        yield(v, error_ptr[0]) if block_given?
        v
      end

      def errors
        errors = {}
        valid? do |valid, error|
          next if error.nil?
          if error.code == NSValidationMultipleErrorsError
            errs = error.userInfo[NSDetailedErrorsKey]
            errs.each do |nserr|
              property = nserr.userInfo['NSValidationErrorKey']
              errors[property] = message_for_error_code(nserr.code, property)
            end
          else
            property = error.userInfo['NSValidationErrorKey']
            errors[property] = message_for_error_code(error.code, property)
          end
        end
        errors
      end
    
      private
      def message_for_error_code(c, prop)
        message = case c
        when NSValidationMissingMandatoryPropertyError
          "can't be blank"
        when NSValidationNumberTooLargeError
          "too large"
        when NSValidationNumberTooSmallError
          "too small"
        when NSValidationDateTooLateError
          "too late"
        when NSValidationDateTooSoonError
          "too soon"
        when NSValidationInvalidDateError
          "invalid date"
        when NSValidationStringTooLongError
          "too long"
        when NSValidationStringTooShortError
          "too short"
        when NSValidationStringPatternMatchingError
          "incorrect pattern"
        when NSValidationRelationshipExceedsMaximumCountError
          "too many"
        when NSValidationRelationshipLacksMinimumCountError
          "too few"
        when NSValidationRelationshipDeniedDeleteError
          "can't delete"
        when NSManagedObjectValidationError
          warnings = entity.propertiesByName[prop].validationWarnings rescue []
          warnings.empty? ? "invalid" : warnings.join(', ')
        end
      end
    
    end
  end
end
