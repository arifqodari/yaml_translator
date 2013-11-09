module YAMLTranslator
  class Translation

    TRANSLATE_URL = 'http://api.microsofttranslator.com/V2/Http.svc/TranslateArray'
    MAX_ARRAY_ELEMENT = 2000


    def initialize(client_id, client_secret)
      @client_id = validate_param(client_id.to_s)
      @client_secret = validate_param(client_secret.to_s)

      @authentication = YAMLTranslator::APIAuthentication.new(client_id, client_secret)
    end

    def translate(from, to)
      @from = validate_param(from)
      @to = validate_param(to)

      hash, xml_requests = build_xml_requests
      arr_translated = translate_yaml(xml_requests)
      hash_translated = build_translated_hash(hash, arr_translated)
      write_to_file(hash_translated)
    end


    private

    def validate_param(param)
      if param.nil? || param.empty?
        YAMLTranslator::ErrorMessage.show("Invalid param")
      else
        return param
      end
    end

    def load_yaml(lang)
      puts "Loading #{lang}.yml file.."

      begin
        return YAML.load_file("#{lang}.yml")[lang]
      rescue Exception => e
        YAMLTranslator::ErrorMessage.show(e)
      end
    end

    def parse_hash(hash)
      begin
        arr = []

        hash.values.each do |element|
          arr += element.kind_of?(Hash) ? parse_hash(element) : [element]
        end

        return arr
      rescue
        YAMLTranslator::ErrorMessage.show("Error parsing yaml file.")
      end
    end

    def load_and_parse_hash(lang)
      hash = load_yaml(lang)
      return hash, parse_hash(hash).each_slice(MAX_ARRAY_ELEMENT).to_a
    end

    def build_xml_requests
      hash, arr = load_and_parse_hash(@from)
      xml_requests = []

      arr.each do |request|
        xml_str = "<TranslateArrayRequest>"
        xml_str += "<AppId />"
        xml_str += "<From>#{@from}</From>"
        xml_str += "<Texts>"

        request.each do |element|
          xml_str += "<string xmlns='http://schemas.microsoft.com/2003/10/Serialization/Arrays'>"
          xml_str += element
          xml_str += "</string>"
        end

        xml_str += "</Texts>"
        xml_str += "<To>#{@to}</To>"
        xml_str += "</TranslateArrayRequest>"

        xml_requests << xml_str
      end

      return hash, xml_requests
    end

    def parse_xml_by_element(xml, element)
      parsed_xml = Nokogiri::XML(xml).remove_namespaces!
      return parsed_xml.xpath(element)
    end

    def translate_yaml(xml_requests)
      puts "Translating.."
      arr_translated = []

      begin
        xml_requests.each do |xml_request|
          response = RestClient.post(
            TRANSLATE_URL,
            xml_request,
            :content_type => "application/xml",
            :'Authorization' => "Bearer #{@authentication.valid_token}"
          )

          if response.code == 200
            parse_xml_by_element(response, "//TranslatedText").each do |element|
              arr_translated << element.content
            end
          end
        end

        return arr_translated
      rescue Exception => e
        YAMLTranslator::ErrorMessage.show(e)
      end
    end

    def replace_hash(hash, array, idx = 0)
      begin
        hash.each do |key, value|
          if value.kind_of?(String)
            new_value = array[idx]
            idx += 1
          else
            new_value, idx = replace_hash(value, array, idx)
          end

          hash[key] = new_value
        end

        return hash, idx
      rescue Exception => e
        YAMLTranslator::ErrorMessage.show(e)
      end
    end

    def build_translated_hash(source, array)
      hash_translated, idx = replace_hash(source, array)
      return hash_translated
    end

    def yaml(hash)
      method = hash.respond_to?(:ya2yaml) ? :ya2yaml : :to_yaml
      string = hash.deep_stringify_keys.send(method)
      string.gsub("!ruby/symbol ", ":").sub("---","").split("\n").map(&:rstrip).join("\n").strip
      string.gsub("\"","")
    end

    def write_to_file(hash)
      puts "Writing #{@to}.yml file.."

      begin
        File.open("#{@to}.yml", 'w') do |out|
          out.write(yaml({@to => hash}))
        end

        puts "Translation complete."
        return true
      rescue Exception => e
        YAMLTranslator::ErrorMessage.show(e)
      end
    end

  end
end
