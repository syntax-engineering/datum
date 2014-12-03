module Plan9

# Though organized differently, this code is reused from 'ImmutableStruct'
# by Theo Hultberg. See https://github.com/iconara/immutable_struct
# Copyright notice mentioned in the LICENSE file.
#
class ImprovedStruct
  def self.new(*attrs, &block)
    init_new(Struct.new(*attrs, &block))
  end

protected

  def self.init_new(struct)
    optionalize_constructor!(struct)
    extend_dup!(struct)
    struct
  end

private

  def self.optionalize_constructor!(struct)
  struct.class_eval do
    alias_method :struct_initialize, :initialize

    def initialize(*attrs)
      if members.size > 1 && attrs && attrs.size == 1 &&
        attrs.first.instance_of?(Hash)
        struct_initialize(*members.map { |m| attrs.first[m.to_sym] })
      else
        struct_initialize(*attrs)
      end
    end

    # Added to Ruby Struct
    #def to_h

  end
  end

  def self.extend_dup!(struct)
  struct.class_eval do
    def dup(overrides={})
      self.class.new(to_h.merge(overrides))
    end
  end
  end

end
class ImmutableStruct < ImprovedStruct

protected
  def self.init_new(struct)
    make_immutable!(struct)
    super(struct)
  end

private
  def self.make_immutable!(struct)
    struct.send(:undef_method, "[]=".to_sym)
    struct.members.each do |member|
      struct.send(:undef_method, "#{member}=".to_sym)
    end
  end

end
end