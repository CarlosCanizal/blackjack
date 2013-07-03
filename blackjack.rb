puts "\nHi! I'm your Croupier Carlos Canizal, what is your name?"
name = gets.chomp.capitalize

$CARDS = {"A"=>11,"2"=>2,"3"=>3,"4"=>4,"5"=>5,"6"=>6,"7"=>7,"8"=>8,"9"=>9,"10"=>10,"J"=>10,"Q"=>10,"K"=>10}
$DECKS = []

def start_game
	$DECKS = [["A","2","3","4","5","6","7","8","9","10","J","Q","K"]*4,
			  ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]*4,
			  ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]*4,
			  ["A","2","3","4","5","6","7","8","9","10","J","Q","K"]*4]
end

def get_total cards
	total = 0
	cards.each do |card|
		card_value = $CARDS[card]
		if card == "A"
			card_value = total + card_value > 21 ? 1 : card_value
		end
		total += card_value
	end
	total
end

def hit_card current_player
	deck = rand($DECKS.length)
	card = rand($DECKS[deck].length)
	current_player[:cards] << $DECKS[deck][card]
	if $DECKS[deck][card] == "A"
		current_player[:order] << $DECKS[deck][card]
	else
		current_player[:order].unshift($DECKS[deck][card])
	end
	$DECKS[deck].delete_at(card)
	current_player
end

commands = ["hit", "stay"]
continue_commands = ["yes","no","y","n"]

puts "\nHi #{name}. Lets play BlackJack!"
while true
	dealer  = {cards:[],order:[]}
	player  = {cards:[],order:[]}
	dealer_play = true
	start_game

	2.times do
		player = hit_card player
	end

	2.times do
		dealer = hit_card dealer
	end

	puts "\nTwo first cards." 
	puts "#{name}: "+player[:cards].join(' , ')
	puts "Croupier: *, #{dealer[:cards][1]}"


	player_total = get_total player[:order]

	if player_total < 21
		puts "\nDo you want 'hit' or 'stay'"
		command = gets.chomp.downcase
		while !commands.include? command
			puts "\nValid commands are: 'hit' or 'stay'"
			command = gets.chomp.downcase
		end
		while command == "hit"
			player = hit_card player
			puts "\nCroupier gives you on more card."
			puts "#{name}: "+player[:cards].join(' , ')
			puts "Croupier: #{dealer[:cards][1]} , *"
			player_total = get_total player[:order]
			if player_total > 21
				puts "\nYou are over 21, You Loose"
				dealer_play = false
				command = "lose"
			elsif player_total == 21
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

	if dealer_play
		dealer_total = get_total dealer[:order]
		while dealer_total < 16
			dealer = hit_card dealer
			dealer_total = get_total dealer[:order]
		end

		puts "\n#{name}: "+player[:cards].join(' , ')
		puts "Total: #{player_total}"

		puts "\nCroupier: "+dealer[:cards].join(' , ')
		puts "Total: #{dealer_total}"


		if dealer_total == player_total
			puts "\nThis is a draw! Nobody wins!!!"
		elsif player_total == 21 && dealer[:cards].length ==2
			puts "\nBlackJack! You win! Congratulations #{name}!"
		elsif player_total > dealer_total || dealer_total > 21
			puts "\nYou win! Congratulations #{name}!"
		else
			puts "\nYou Lose!!! Sorry #{name}, better luck next time."
		end
	end

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







