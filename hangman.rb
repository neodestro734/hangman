class Hangman

	attr_accessor :secret_length, :guesser, :knower

	def initialize(guesser, knower)
		@guesser = guesser
		@knower = knower
	end

	def run
		guesses_left = 10
		secret_length = @knower.pick_secret_word
		@guesser.receive_secret_length(secret_length)
		cur_word = '_' * secret_length
		while guesses_left > 0
			puts "\nSecret word: #{cur_word}"
			puts @knower.secret_word
			puts "You have #{guesses_left} guesses left."

			new_guess = @guesser.guess
			correct_indices = @knower.check_guess(new_guess)
			correct_indices.each { |i| cur_word[i] = new_guess }

			break if cur_word.each_char.none? { |char| char == '_' }
			guesses_left -= 1 if correct_indices.empty?

			@guesser.handle_guess_response(new_guess, cur_word)
		end

		if guesses_left > 0
			puts "\nYou Won!!"
		else
			puts "\nYou lost :/"
		end
	end
end

class HumanPlayer
	def pick_secret_word

	end

	#DONE
	def receive_secret_length(secret_length)
		puts "The word is #{secret_length} characters long."
	end

	#DONE
	def guess
		guess = ''
		loop do
			puts "Please guess a letter:"
			guess = gets.chomp
			break if guess.length == 1
			puts "\nNot a valid guess."
		end
		guess
	end

	def check_guess

	end

	def handle_guess_response(new_guess, cur_word)

	end
end

class ComputerPlayer
	
	attr_accessor :dictionary, :secret_word

	#DONE
	def initialize(dictionary)
		@dictionary = File.readlines(dictionary).map(&:chomp)
	end

	#DONE
	def pick_secret_word
		@secret_word = @dictionary.sample
		secret_word.length
	end

	def receive_secret_length(secret_length)

	end

	def guess

	end

	#DONE
	def check_guess(new_guess)
		correct_indices = []
		@secret_word.each_char.with_index do |char, i|
			correct_indices << i if (char == new_guess)
		end
		correct_indices
	end

	def handle_guess_response(new_guess, cur_word)

	end
end

comp = ComputerPlayer.new('dictionary.txt')
human = HumanPlayer.new
hangman = Hangman.new(human, comp)
# p 'run now'
hangman.run