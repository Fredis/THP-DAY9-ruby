require 'open-uri'
require 'nokogiri'

PAGE_URL = 'https://coinmarketcap.com/all/views/all/'

def coin
    page = Nokogiri::HTML(open(PAGE_URL))
    value = page.css(".price")
    array_value = []
    value.each do |node|
        array_value.push(node.text)
    end
    names = page.css(".currency-name-container.link-secondary")
    array_names = []
    names.each do |node|
        array_names.push(node.text)
    end
    super_array = []
    counter = 0
    while counter < array_value.size
        hash = {:money => array_names[counter], :price => array_value[counter]}
        super_array << hash
        counter += 1
    end 
    return super_array
end

puts coin 
 
