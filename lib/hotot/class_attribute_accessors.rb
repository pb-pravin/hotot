module Hotot
  module ClassAttributeAccessors
  
    def cattr_reader(*syms)
      syms.each do |sym|
        raise NameError.new("invalid class attribute name: #{sym}") unless sym =~ /^[_A-Za-z]\w*$/
        class_eval(<<-EOS, __FILE__, __LINE__ + 1)
                unless defined? @@#{sym}
                  @@#{sym} = nil
                end

                def self.#{sym}
                  @@#{sym}
                end
              EOS
      end
    end
    
  end
end