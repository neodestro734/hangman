class Hangman

	attr_accessor :secret_length, :guesser, :knower

	#DONE
	def initialize(guesser, knower)
		@guesser = guesser
		@knower = knower
	end

	#DONE
	def run
		guesses_left = 10
		secret_length = @knower.pick_secret_word
		@guesser.receive_secret_length(secret_length)
		cur_word = '_' * secret_length
		while guesses_left > 0
			puts "\nSecret word: #{cur_word}"
			# puts @knower.secret_word # only for computer player knowers
			puts "You have #{guesses_left} guesses left."

			new_guess = @guesser.guess.downcase
			correct_indices = @knower.check_guess(new_guess, secret_length)
			correct_indices.each { |i| cur_word[i] = new_guess }

			break if cur_word.each_char.none? { |char| char == '_' }
			guesses_left -= 1 if correct_indices.empty?

			@guesser.handle_guess_response(new_guess, correct_indices)
		end

		if guesses_left > 0
			puts "\n#{@guesser.name} guessed \"#{cur_word}\" with #{guesses_left} guesses left!!"
		else
			puts "\n#{@guesser.name} could not guess it :/"
		end
	end
end

class HumanPlayer

	attr_reader :name

	#DONE
	def initialize(name)
		@name = name
	end

	#DONE
	def pick_secret_word
		begin
			puts "\nPlease pick a secret word. How long is it?"
			secret_length = Integer(gets.chomp)
			if secret_length > 20
				raise ArgumentError.new#("Word is #{secret_length} characters.")
			end
		rescue
			print "\nNot a valid length."
			retry
		end
		secret_length
	end

	#DONE
	def receive_secret_length(secret_length)
		puts "The word is #{secret_length} characters long."
	end

	#DONE
	def guess
		guess = ''
		begin
			puts "Please guess a letter:"
			guess = gets.chomp
			if guess.nil? || guess.length > 1
				raise ArgumentError.new("\nNot a valid guess.")
			end
			begin
				Integer(guess)
				raise ArgumentError.new("\nCannot use integers")
			end
		rescue ArgumentError => e
			puts e.message
			retry
		end
		guess
	end

	#DONE
	def check_guess(new_guess, secret_length)
		begin
			puts "\nPlease select the indices, separated by commas, that the computer "
			puts "chose correctly (enter for no indices:"

			correct_indices = gets.chomp.split(',').map(&:to_i)

			if correct_indices.any? { |i| i > secret_length - 1 }
				raise ArgumentError.new("\nIndex is out of range")
			end
		rescue => e
			puts e.message
			retry
		end
		correct_indices
	end

	#DONE
	def handle_guess_response(new_guess, cur_word)
		#nothing needed here
	end
end

class ComputerPlayer
	
	attr_accessor :dictionary, :secret_word, :letters_guessed, :name

	#DONE
	def initialize(dictionary)
		@dictionary = File.readlines(dictionary).map(&:chomp)
		@letters_guessed = []
		@name = "Hal"
	end

	#DONE
	def pick_secret_word
		@secret_word = @dictionary.sample
		secret_word.length
	end

	#DONE
	def receive_secret_length(secret_length)
		@dictionary = @dictionary.select { |word| word.length == secret_length }
	end

	#DONE
	def guess
		
		#create a frequency hash of all guessable letters
		freq_hash = Hash.new { |h, k| h[k] = 0 }
		@dictionary.each do |dic_word|
			dic_word.each_char do |d_char|
				freq_hash[d_char] += 1 unless @letters_guessed.include?(d_char)
			end
		end

		cur_max = 0
		cur_max_let = ''
		freq_hash.each do |k, v|
			if v > cur_max
				cur_max_let = k
				cur_max = v
			end
		end

		comp_guess = cur_max_let
		puts "Computer guesses: #{comp_guess}"
		comp_guess
	end

	#DONE
	def check_guess(new_guess, secret_length)
		correct_indices = []
		@secret_word.each_char.with_index do |char, i|
			correct_indices << i if (char == new_guess)
		end
		correct_indices
	end

	#DONE
	def handle_guess_response(my_last_guess, correct_indices)
		@letters_guessed << my_last_guess

		@dictionary = @dictionary.select do |dic_word|
			keep = true
			dic_word.each_char.with_index do |d_char, i|
				# where letter guessed is at the wrong index
				if (d_char == my_last_guess && !correct_indices.include?(i))
					keep = false
					break
				end
				# where correct index value is different from my_last_guesss
				if (correct_indices.include?(i) && d_char != my_last_guess)
					keep = false
					break
				end
			end
			keep
		end
	end
end

if __FILE__ == $PROGRAM_NAME
	# comp = ComputerPlayer.new('dictionary.txt')
	# human = HumanPlayer.new('Phil')
	# comp2 = ComputerPlayer.new('dictionary.txt')
	# hangman = Hangman.new(human, comp)
	# hangman = Hangman.new(comp, comp2)
	# hangman = Hangman.new(comp, human)
	# hangman.run
end