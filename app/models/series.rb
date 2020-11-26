class Series
  SERIES = ['quiptic', 'quick', 'weekend', 'cryptic', 'speedy', 'prize', 'everyman']
  LOCAL_FILE_LIST_CACHE_TIMEOUT = 10

  def self.get_all
    self.get_local
    #keys = SERIES.map{|name| "crossword-series-#{name}"}
    #series = redis.mget(*keys).map{|a_series| JSON.parse(a_series || '[]') }
    #SERIES.zip(series).map do |name, crossword_datas|
    #  [name, crossword_datas.map {|crossword_data| Crossword.new(crossword_data)}]
    #end.select{|name, series| series.any? }
  end

  def self.get_local
    local_data = {}
    local_files = Dir.glob('data/cryptic/*').select { |e| File.file? e }
      
    local_files.each do |path|
      file_json = JSON.parse(File.read(path))
      dt = Time.at(file_json["date"]/1000).utc.to_datetime.strftime("%FT%TZ")
      next if dt > Time.now
      local_data[file_json["crosswordType"]] ||= []
      local_data[file_json["crosswordType"]].push(Crossword.new({
        'series' => file_json["crosswordType"],
        'file_path' => path,
        'title' => file_json["name"],
        'source' => 'local',
        'identifier' => file_json["id"],
        'date' => dt
      }))
    end
    local_data
  end

  def self.redis
    @redis ||= Redis.new
  end
end
