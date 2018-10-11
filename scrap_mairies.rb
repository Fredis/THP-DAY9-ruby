require 'rubygems'
require 'nokogiri'
require 'open-uri'

#Méthode pour récupérer l'adresse email d'une mairie à partir de sa page
def get_the_email_of_a_townhall_from_its_webpage(page_url)
	data = Nokogiri::HTML(open(page_url))
	data.xpath("/html/body/div[1]/main/section[2]/div/table/tbody/tr[4]/td[2]").each do |node|
		puts node.text
	end
end

#Méthode pour récupérer les liens de pages relatives à chaque mairie et qui exécuter la première méthode sur la base des liens récupérés
def get_all_the_urls_of_val_doise_townhalls
	page_url = "http://annuaire-des-mairies.com/val-d-oise.html"
	get_townhalls_URL = Nokogiri::HTML(open(page_url))
	#get_townhalls_URL.css('a.lientxt').each do |url|
	#	puts url['href']
	array_links = []
	get_townhalls_URL.xpath('//a[@class = "lientxt"]').each do |url| #solution avec XPATH autrement au-dessus en commentaires, la solution avec CSS
		link = url['href']
		link[0] = '' #on enlève les points sur les URLs récupérées
		link = "http://annuaire-des-mairies.com#{link}" #on formatte au bon format d'URL
		array_links << link #on ajoute nos liens dans un tableau
	end
	
	array_links.each do |url|
		get_the_email_of_a_townhall_from_its_webpage(url) #on lance la première méthode afin de récupérer les adresses emails par page de mairie
	end

end

get_all_the_urls_of_val_doise_townhalls