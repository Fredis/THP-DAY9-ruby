require 'rubygems'
require 'nokogiri'
require 'open-uri'


#Méthode pour récupérer l'adresse email d'une mairie à partir de sa page
def get_the_email_of_a_townhall_from_its_webpage(page_url)
	data = Nokogiri::HTML(open(page_url))
	data.xpath("/html/body/div[1]/main/section[2]/div/table/tbody/tr[4]/td[2]").each do |node|
	return node.text
	end
end

#Méthode pour récupérer les liens de pages relatives à chaque mairie et qui exécuter la première méthode sur la base des liens récupérés
def get_all_the_urls_of_val_doise_townhalls
	page_url = "http://annuaire-des-mairies.com/val-d-oise.html"
	get_townhalls_URL = Nokogiri::HTML(open(page_url))
	#get_townhalls_URL.css('a.lientxt').each do |url|
	#	puts url['href']
	array_links = []
	get_townhalls_URL.xpath('//a[@class = "lientxt"]').each do |url| #Solution avec XPATH autrement au-dessus en commentaires, la solution avec CSS
		link = url['href']
		link[0] = '' #On enlève les points sur les URLs récupérées
		link = "http://annuaire-des-mairies.com#{link}" #On formatte au bon format d'URL
		hash_townhall_info = {:name => url.text, :townhall_mail => link} #Création de hash
		array_links << hash_townhall_info #Ajout du hash dans un tableau
	end


	array_links.each do |hash_townhall|
		hash_townhall[:townhall_mail] = get_the_email_of_a_townhall_from_its_webpage(hash_townhall[:townhall_mail]) #On fait passer les adresses mail dans townhall_mail à la place des URL grâce à la première méthode
	end	
	puts array_links

end

get_all_the_urls_of_val_doise_townhalls