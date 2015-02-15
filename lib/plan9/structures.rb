# @api private
module Plan9 # Module for simple code reuse between various projects.

# @private
class ImprovedStruct # A few improvements to a Ruby Struct
#
# Re-organized slightly, this code is reused from 'ImmutableStruct'
# by Theo Hultberg. See https://github.com/iconara/immutable_struct
# Copyright notice mentioned in the LICENSE file.
#
  # @private
  def self.new(*attrs, &block)
    init_new(Struct.new(*attrs, &block))
  end

protected
  # @private
  def self.init_new(struct)
    optionalize_constructor!(struct)
    extend_dup!(struct)
    struct
  end

private
  # @private
  def self.optionalize_constructor!(struct)
    struct.class_eval do
      alias_method :struct_initialize, :initialize

      # @private
      def initialize(*attrs)
        if is_hash_case?(*attrs)
          struct_initialize(*members.map { |m| attrs.first[m.to_sym] })
        else
          struct_initialize(*attrs)
        end
      end

    protected
      # @private
      def is_hash_case?(*a)
      # @return (bool) true if attrs are Hash, false otherwise
        members.size > 1 && a && a.size == 1 && a.first.instance_of?(Hash)
      end
    end
  end
  # @private
  def self.extend_dup!(struct)
    struct.class_eval do
      def dup(overrides={})
        self.class.new(to_h.merge(overrides))
      end
    end
  end
end


# @private
class ImmutableStruct < ImprovedStruct # A read-only Struct
# Re-organized slightly, this code is reused from 'ImmutableStruct'
# by Theo Hultberg. See https://github.com/iconara/immutable_struct
# Copyright notice mentioned in the LICENSE file.

protected
  # @private
  def self.init_new(struct)
    make_immutable!(struct)
    super(struct)
  end

private
  # @private
  def self.make_immutable!(struct)
    # removes the member= method, to prevent write
    struct.send(:undef_method, "[]=".to_sym)
    struct.members.each do |member|
      struct.send(:undef_method, "#{member}=".to_sym)
    end
  end

end
end