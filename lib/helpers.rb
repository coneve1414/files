def grouped_downloads
  result = {}
  pattern = /MinePass-([\w]+)\W/
  @items.find_all('/external/downloads/*').map do |item|
    name = item[:basename]
    m = name.match(pattern)
    next unless m
    group = m[1].gsub(/^([A-Z][a-z]+)([A-Z].*)$/, '\\1 \\2')
    result[group] ||= []
    result[group] << item
  end
  result
end
