module YAMLTranslator
  class ErrorMessage

    def self.show(message, code = nil)
      abort "Error! #{code}: #{message}"
    end

  end
end
