require 'pry'

card_equivalence = {"A"=>11,"2"=>2,"3"=>3,"4"=>4,"5"=>5,"6"=>6,"7"=>7,"8"=>8,"9"=>9,"10"=>10,"J"=>10,"Q"=>10,"K"=>10}
decks = []

def start_game 
	decks = [["A","2","3","4","5","6","7","8","9","10","J","Q","K"]*4,
			 ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]*4,
			 ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]*4,
			 ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]*4]
end

def get_total(cards,card_equivalence)
	total = 0
	cards.each do |card|
		card_value = card_equivalence[card]
		if card == "A"
			card_value = total + card_value > 21 ? 1 : card_value
		end
		total += card_value
	end
	total
end

def hit_card(current_player,decks)
	deck = rand(decks.length)
	card = rand(decks[deck].length)
	current_player[:cards] << decks[deck][card]
	if decks[deck][card] == "A"
	   current_player[:order] << decks[deck][card]
	else
		current_player[:order].unshift(decks[deck][card])
	end
	decks[deck].delete_at(card)
	{current_player:current_player,decks:decks}
end

commands = ["hit", "stay"]
continue_commands = ["yes","no","y","n"]

while true

	puts "\nHi! I'm your Croupier Carlos Canizal, how many players? (1-4)"
	players_total = gets.chomp.to_i

	while players_total < 1 || players_total > 4
		puts "\nPlease type a number between 1 and 4"
		players_total = gets.chomp.to_i
	end

	players = []

	players_total.times do |player|
		puts "\nPlease type the player's #{player+1} name"
		player_name = gets.chomp.capitalize
		players << {name:player_name,player_cards:{},total:0}
	end

	puts "\nLets play BlackJack!"

	dealer  = {cards:[],order:[]}

	players.each do |player|
		player[:player_cards] = {cards:[],order:[]}
	end

	#dealer_play = true
	decks = start_game

	players.each do |player|
		2.times do
			hit = hit_card(player[:player_cards],decks)
			player[:player_cards] = hit[:current_player]
			decks = hit[:decks]
		end
	end

	2.times do
		hit = hit_card(dealer,decks)
		dealer = hit[:current_player]
		decks = hit[:decks]
	end

	puts "\nTwo first cards." 
	players.each do |player|
		puts "#{player[:name]}: "+player[:player_cards][:cards].join(' , ')
	end
	puts "Croupier: *, #{dealer[:cards][1]}"


	players.each do |player|
		player[:total] = get_total(player[:player_cards][:order], card_equivalence)
		puts "----------------------------------"
		puts "\nNow Playing: #{player[:name]}"
		if player[:total] < 21
			puts "\nDo you want 'hit' or 'stay'"
			command = gets.chomp.downcase
			while !commands.include? command
				puts "\nValid commands are: 'hit' or 'stay'"
				command = gets.chomp.downcase
			end
			while command == "hit"
				hit = hit_card(player[:player_cards],decks)
				player[:player_cards] = hit[:current_player]
				decks = hit[:decks]
				puts "\nCroupier gives you on more card."
				puts "#{player[:name]}: "+player[:player_cards][:cards].join(' , ')
				puts "Croupier: #{dealer[:cards][1]} , *"
				player[:total] = get_total(player[:player_cards][:order], card_equivalence)
				if player[:total] > 21
					puts "\nYou are over 21, You Lose"
					dealer_play = false
					command = "lose"
				elsif player[:total] == 21
					puts "\nYou are in 21"
					command = "stay"
				else
					puts "\nDo you want 'hit' or 'stay'"
					command = gets.chomp.downcase
					while !commands.include? command
						puts "\nValid commands are: 'hit' or 'stay'"
						command = gets.chomp.downcase
					end
				end
			end
		end
	end

	#if dealer_play
		dealer_total = get_total(dealer[:order], card_equivalence)
		while dealer_total <= 16
			hit = hit_card(dealer,decks)
			dealer = hit[:current_player]
			decks = hit[:decks]
			dealer_total = get_total(dealer[:order], card_equivalence)
		end

		puts "----------------------------------"

		puts "\nCroupier: "+dealer[:cards].join(' , ')
		puts "Total: #{dealer_total}"


		players.each do |player|
			puts "\n#{player[:name]}: "+player[:player_cards][:cards].join(' , ')
			puts "Total: #{player[:total]}"

			if player[:total] > 21
				puts "\n#{player[:name]} Loses!!! Sorry #{player[:name]}, better luck next time.\n"
			elsif dealer_total == player[:total]
				puts "\nThis is a draw!"
			elsif player[:total] == 21 && player[:player_cards][:cards].length ==2
				puts "\nBlackJack! #{player[:name]} wins! Congratulations #{player[:name]}!"
			elsif player[:total] > dealer_total || dealer_total > 21
				puts "\n#{player[:name]} wins! Congratulations #{player[:name]}!"
			else
				puts "\n#{player[:name]} Loses!!! Sorry #{player[:name]}, better luck next time.\n"
			end
		end
		puts "----------------------------------"
	#end

	puts "\nDo you want to play again? Yes/No"
	play_again = gets.chomp.downcase

	while !continue_commands.include? play_again
		puts "\nValid commands are: 'Yes', 'No', 'Y', 'N', 'yes', 'no', 'y', 'n' "
		play_again = gets.chomp.downcase
	end

	if play_again == "no" || play_again == "n"
		puts "\nThanks everybody for playing! See you later\n"
		exit
	end
end


