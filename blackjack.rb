require 'pry'

puts "\nHi! I'm your Croupier Carlos Canizal, what is your name?"
name = gets.chomp.capitalize

decks = []
suits = %w(Spades Diamonds Hearts Clubs)


def start_game 
	suits = %w(Spades Diamonds Hearts Clubs)
	values = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]
	deck = suits.product(values)
	decks = [deck]
end

def print_cards cards
	cards.map { |card| "#{card[1]} #{card[0]}" }
end

def get_total(cards)
	card_equivalence = {"A"=>11,"2"=>2,"3"=>3,"4"=>4,"5"=>5,"6"=>6,"7"=>7,"8"=>8,"9"=>9,"10"=>10,"J"=>10,"Q"=>10,"K"=>10}
	total = 0
	cards.each do |card|
		card_value = card_equivalence[card[1]]
		if card == "A"
			card_value = total + card_value > 21 ? 1 : card_value
		end
		total += card_value
	end
	total
end

def print_total(cards)
	total = get_total(cards)
	"Total: #{total}"
end

def hit_card(current_player,decks)
	deck = rand(decks.length)
	card = rand(decks[deck].length)
	current_player[:cards] << decks[deck][card]
	if decks[deck][card][1] == "A"
	   current_player[:order] << decks[deck][card]
	else
		current_player[:order].unshift(decks[deck][card])
	end
	decks[deck].delete_at(card)
	{current_player:current_player,decks:decks}
end

commands = ["hit", "stay"]
continue_commands = ["yes","no","y","n"]

puts "\nHi #{name}. Lets play BlackJack!"
while true
	dealer  = {cards:[],order:[]}
	player  = {cards:[],order:[]}
	dealer_play = true
	decks = start_game

	2.times do
		hit = hit_card(player,decks)
		player = hit[:current_player]
		decks = hit[:decks]
	end

	2.times do
		hit = hit_card(dealer,decks)
		dealer = hit[:current_player]
		decks = hit[:decks]
	end

	puts "\nTwo first cards." 
	puts "----------------------------------"
	puts "#{name}: "+print_cards(player[:cards]).join(' , ')
	puts print_total(player[:order])
	puts "----------------------------------"
	puts "Croupier: *, "+ print_cards([dealer[:cards][1]]).join(',')
	puts "----------------------------------"

	player_total = get_total(player[:order])

	if player_total < 21
		puts "\nDo you want 'hit' or 'stay'"
		command = gets.chomp.downcase
		while !commands.include? command
			puts "\nValid commands are: 'hit' or 'stay'"
			command = gets.chomp.downcase
		end
		while command == "hit"
			hit = hit_card(player,decks)
			player = hit[:current_player]
			decks = hit[:decks]
			puts "----------------------------------"
			puts "\nCroupier gives you on more card."
			puts "#{name}: "+print_cards(player[:cards]).join(' , ')
			puts print_total(player[:order])
			puts "Croupier: *, "+ print_cards([dealer[:cards][1]]).join(',')
			player_total = get_total(player[:order])
			if player_total > 21
				puts "\nYou are over 21, You Loose"
				dealer_play = false
				command = "lose"
			elsif player_total == 21
				puts "\nYou are in 21"
				command = "stay"
			else
				puts "----------------------------------"
				puts "\nDo you want 'hit' or 'stay'"
				command = gets.chomp.downcase
				while !commands.include? command
					puts "\nValid commands are: 'hit' or 'stay'"
					command = gets.chomp.downcase
				end
			end
		end
	end

	if dealer_play
		dealer_total = get_total(dealer[:order])
		while dealer_total <= 16
			hit = hit_card(dealer,decks)
			dealer = hit[:current_player]
			decks = hit[:decks]
			dealer_total = get_total(dealer[:order])
		end

		puts "----------------------------------"
		puts "\n#{name}: "+print_cards(player[:cards]).join(' , ')
		puts print_total(player[:order])

		puts "\nCroupier: "+print_cards(dealer[:cards]).join(' , ')
		puts print_total(dealer[:order])
		puts "----------------------------------"


		if dealer_total == player_total
			puts "\nThis is a draw! Nobody wins!!!"
		elsif player_total == 21 && player[:cards].length ==2
			puts "\nBlackJack! You win! Congratulations #{name}!"
		elsif player_total > dealer_total || dealer_total > 21
			puts "\nYou win! Congratulations #{name}!"
		else
			puts "\nYou Lose!!! Sorry #{name}, better luck next time."
		end
	end

	puts "----------------------------------"
	puts "\nDo you want to play again? Yes/No"
	play_again = gets.chomp.downcase

	while !continue_commands.include? play_again
		puts "\nValid commands are: 'Yes', 'No', 'Y', 'N', 'yes', 'no', 'y', 'n' "
		play_again = gets.chomp.downcase
	end

	if play_again == "no" || play_again == "n"
		puts "\nThanks for playing! See you #{name}\n"
		puts
		exit
	end
end


