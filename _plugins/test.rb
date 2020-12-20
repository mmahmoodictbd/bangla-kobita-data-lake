module JsonView
  class Generator < Jekyll::Generator
    def generate(site)
      jsons = {}
      site.collections["kobita"].docs.each do |doc|
        unless jsons.key?(doc["post_type"])
          jsons[doc["post_type"]] = []
        end
        jsons[doc["post_type"]].push(doc.data)
      end

      jsons.each do |json_item_key, json_item_list|
        json_file = create_file("./generated/" + json_item_key + "s", "json")
        json_file.puts(json_item_list.to_json)
        json_file.close
        site.static_files << JsonView::DynamicStaticFile.new(site, site.source, "/generated/", json_item_key + "s.json", "/assets/")
      end


    end

    def create_file(path, extension)
      dir = File.dirname(path)

      unless File.directory?(dir)
        FileUtils.mkdir_p(dir)
      end

      path << ".#{extension}"
      File.new(path, 'w')
    end
  end

  class DynamicStaticFile < Jekyll::StaticFile
    def initialize(site, base, dir, name, dest)
      super(site, base, dir, name)
      @name = name
      @dest = dest
    end
    def destination(dest)
      @destination ||= {}
      @destination[@dest] ||= @site.in_dest_dir(@dest, Jekyll::URL.unescape_path(url))
    end
  end

end