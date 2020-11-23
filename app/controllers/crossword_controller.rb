

class CrosswordController < ApplicationController
  def show
    raise ActionController::RoutingError.new('Source not Found') unless params[:source].in?(['guardian','local'])
    raise ActionController::RoutingError.new('Series not Found') unless params[:series].in?(Series::SERIES)
    @crossword = crossword
    @parsed_crossword = crossword
    @url = url
  end

  def crossword_identifier
    [params[:source], params[:series], params[:identifier]].join('/')
  end
  helper_method :crossword_identifier

  def crossword
    if redis.exists(crossword_identifier)
      JSON.parse(redis.get(crossword_identifier))
    else
      if params[:source] == 'local'
        JSON.parse(get_crossword_data_from_disk.tap {|data| redis.set(crossword_identifier, data) })
      else
        JSON.parse(get_crossword_data.tap {|data| redis.set(crossword_identifier, data) })
      end
    end
  end

  def get_crossword_data
    response = Faraday.get(url)
    html = Nokogiri::HTML(response.body)
    crossword_element = html.css('.js-crossword')
    raise ActionController::RoutingError.new('Element not Found') unless crossword_element.any?
    crossword_element.first['data-crossword-data']
  end
  
  def get_crossword_data_from_disk
    path = "./data/#{params[:series]}/#{params[:identifier]}.json"
    file = File.read(path)
    return file
  end

  def url
    "https://www.theguardian.com/crosswords/#{params[:series]}/#{params[:identifier]}"
  end

  def redis
    @redis ||= Redis.new
  end
end
