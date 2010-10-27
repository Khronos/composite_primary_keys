module CompositePrimaryKeys
  ID_SEP     = ','
  ID_SET_SEP = ';'

  module ArrayExtension
    def to_composite_keys
      CompositeKeys.new(self)
    end

    def to_composite_ids
#      Array.new(self)
      CompositeIds.new(self)
    end
  end

  class CompositeKeys < Array
    def to_s
      # Doing this makes it easier to parse Base#[](attr_name)
      join(ID_SEP)
    end
  end

  #Added this back in to support dates as composite ids, based on a patch
  #that was posted to the google group.
  #Patching this way probably isn't the best but this works for now
  class CompositeIds < Array
    def to_s
      collect {|id| id_to_s(id)}.join(ID_SEP)
    end

    private
    def id_to_s(value)
      Rails.logger.warn("In id_to_s: #{value}")
      case value
      when Date, DateTime, Time
        value.to_s(:db)
      else
        value
      end
    end
  end
end

Array.send(:include, CompositePrimaryKeys::ArrayExtension)
