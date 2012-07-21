module TrackIt

  class Wrapper
    include ActiveModel::AttributeMethods
    attribute_method_suffix '_changed?'
    attr_reader :model

    def initialize(model)
      @model = model
    end

    def changed?
      model.tracked_attributes != 0
    end
    
    def changed
      changed = []
      bits_num = tracked_attributes.size
      (bits_num-1).downto(0) do |i|
        changed << tracked_attributes[i] if model.tracked_attributes[i] == 1
      end
      changed
    end

    def set_changed(attr)
      @model.tracked_attributes |= 2 ** tracked_attributes.index(attr)
    end

    def set_unchanged(attr)
      @model.tracked_attributes &= ~(2 ** tracked_attributes.index(attr))
    end

    def set_all_unchanged
      @model.tracked_attributes = 0
    end

    def set_all_changed
      @model.tracked_attributes |= (~0)
    end


    protected

    def attributes
      model.attributes.slice(*tracked_attributes.map(&:to_s))
    end

    def model_class
      model.class
    end

    def tracked_attributes
      @tracked_attributes ||= model.class.tracked_attributes
    end
    
    def attribute_changed?(attr)
      model.tracked_attributes[tracked_attributes.index(attr.to_sym)] == 1
    end
  end

  
end
