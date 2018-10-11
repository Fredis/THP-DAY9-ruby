require 'rubygems'
require 'nokogiri'
require 'open-uri'


#Méthode pour récupérer l'adresse email d'un député à partir de sa page
def get_the_email_of_a_deputy_from_its_webpage(page_url)
	data = Nokogiri::HTML(open(page_url))
	data.xpath('//*[@id="haut-contenu-page"]/article/div[3]/div/dl/dd[4]/ul/li[1]/a').each do |node|

	mail = node['href']
	mail_size = mail.size
	mail = mail.slice(7...mail_size) #L'ensemble nous permet de retirer le substring "mailto:"

	return mail
	end
end

#Méthode pour récupérer les liens de pages relatives à chaque député et qui exécuter la première méthode sur la base des liens récupérés
def get_all_the_urls_of_deputy
	page_url = "http://www2.assemblee-nationale.fr/deputes/liste/alphabetique"
	get_deputy_URL = Nokogiri::HTML(open(page_url))
	array_links = []
	get_deputy_URL.css('div#deputes-list li a').each do |url| #Solution avec XPATH
		link = url['href']
		link = "http://www2.assemblee-nationale.fr#{link}" #On formatte au bon format d'URL

		deputy_name = url.text
		deputy_name_array = deputy_name.split
		deputy_name_array = deputy_name_array.drop(1) #On enlève les "M."/"Mme"
		first_name = deputy_name_array[0] #On extrait le premier mot du string, soit le prénom
		size = deputy_name_array.size
		last_name = deputy_name_array[1...size].join(" ") #On récupère le nom en prenant les derniers éléments de l'array (pour récupérer les noms composés) et on utilise la méthode .join(" ") pour les mettre dans un string

		hash_deputy_info = {:first_name => first_name, :last_name => last_name, :email => link} #Création de hash
		array_links << hash_deputy_info #Ajout du hash dans un tableau
	end

	array_links.each do |hash_deputy|
		hash_deputy[:email] = get_the_email_of_a_deputy_from_its_webpage(hash_deputy[:email]) #On fait passer les adresses mail dans email à la place des URL grâce à la première méthode
	end	
	puts array_links

end

get_all_the_urls_of_deputy