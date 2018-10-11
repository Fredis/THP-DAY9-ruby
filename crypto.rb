require 'open-uri'
require 'nokogiri'

PAGE_URL = 'https://coinmarketcap.com/all/views/all/'

def coin
    page = Nokogiri::HTML(open(PAGE_URL))
    value = page.css(".price")
    array_value = []
    value.each do |node| #On récupère les prix et on les met dans un array
        array_value.push(node.text)
    end
    names = page.css(".currency-name-container.link-secondary")
    array_names = []
    names.each do |node| #On récupère les currencies et on les met dans un array
        array_names.push(node.text)
    end
    super_array = []
    counter = 0
    while counter < array_value.size #On créer un array qui contient tous les hashs regroupant le couple currency-price
        hash = {:money => array_names[counter], :price => array_value[counter]}
        super_array << hash
        counter += 1
    end 
    return super_array
end

loop do #Partie qui permet d'exécuter en continu le programme et de relancer toute les heures la méthode coin
  puts coin 
  sleep 3600
end

 
