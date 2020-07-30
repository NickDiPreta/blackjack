class String
  def black; "\033[30m#{self}\033[0m" end
  def red; "\033[31m#{self}\033[0m" end
  def green; "\033[32m#{self}\033[0m" end
  def brown; "\033[33m#{self}\033[0m" end
  def blue; "\033[34m#{self}\033[0m" end
  def magenta; "\033[35m#{self}\033[0m" end
  def cyan; "\033[36m#{self}\033[0m" end
  def gray; "\033[37m#{self}\033[0m" end
end

class Human
  attr_accessor :name, :bankroll, :hand

  def initialize(name, bankroll = 100, hand = [])
    @name = name
    @bankroll = bankroll
    @hand = hand
  end
end

class House
  attr_accessor :name, :bankroll, :hand

  def initialize(name, bankroll = 10000, hand = [])
    @name = name
    @bankroll = bankroll
    @hand = hand
  end
end

class Card
  @@Facecards = ["Jack", "Queen", "King"]
  attr_accessor :face, :suit
  attr_reader :value

  def initialize(value, suit)
    if (2..10).include?(value.to_i)
      @value = value
      @face = value
      @suit = suit
    elsif @@Facecards.include?(value)
      @value = 10
      @face = value
      @suit = suit
    else
      @value = 11
      @face = value
      @suit = suit
    end
  end
end

class Deck
  attr_accessor :suit, :options

  def initialize
    @options = %w[Jack Queen King Ace 2 3 4 5 6 7 8 9 10]
    @suits = %w[hearts diamonds spades clubs]
  end

  def fill
    set = @suits.map { |e| @options.map { |j| Card.new(j, e) } }
  end
end

class Game
  @@Encodes = "#{"\u2664".encode("utf-8")} #{"\u2661".encode("utf-8")} #{"\u2662".encode("utf-8")} #{"\u2667".encode("utf-8")}"
  attr_accessor :deck

  def init
    @computer_name = "Jarvis"
  end

  def new_game
    puts "\nWelcome, let's play blackjack #{@@Encodes} ... loser. ".red
    print "What's your name? "
    @player_name = gets.chomp
    puts "\nNiCE tO meEt YoU #{@player_name}. I'll deal you in...".red
    @deck = Deck.new
    deal_player
  end

  def deal_player
    @ary = @deck.fill.flatten.shuffle!
    @card1 = @ary.pop()
    @card2 = @ary.pop()
    @player = Human.new(@player_name, 100, [@card1, @card2])
    puts "Your current bankroll is #{@player.bankroll}"
    puts "\n#{@player_name}'s' Hand:".cyan
    if @player.hand[1].suit == "spades"
      @player.hand[1].suit = "\u2664".encode("utf-8")
    elsif @player.hand[1].suit == "hearts"
      @player.hand[1].suit = "\u2661".encode("utf-8")
    elsif @player.hand[1].suit == "clubs"
      @player.hand[1].suit = "\u2662".encode("utf-8")
    elsif @player.hand[1].suit == "diamonds"
      @player.hand[1].suit = "\u2667".encode("utf-8")
    end
    if @player.hand[0].suit == "spades"
      @player.hand[0].suit = "\u2664".encode("utf-8")
    elsif @player.hand[0].suit == "hearts"
      @player.hand[0].suit = "\u2661".encode("utf-8")
    elsif @player.hand[0].suit == "clubs"
      @player.hand[0].suit = "\u2662".encode("utf-8")
    elsif @player.hand[0].suit == "diamonds"
      @player.hand[0].suit = "\u2667".encode("utf-8")
    end
    puts "Card One : ".magenta + @player.hand[0].value.to_s.green + " of ".blue + @player.hand[0].suit.cyan
    puts "Card Two : ".magenta + @player.hand[1].value.to_s.green + " of ".blue + @player.hand[1].suit.cyan
    hum = @player.hand[0].value.to_i + @player.hand[1].value.to_i
    puts "Player has #{@player.hand[0].value.to_i + @player.hand[1].value.to_i}!".brown
    if hum == 21
      puts "BLACKJACK!".green
      evaluate_winner(hum)
      return
    end
    @hit_request = "y"
    puts "\n\nHIT? (y/n)".red
    @hit_request = gets.chomp
    while @hit_request == "y"
      hum += @ary.pop.value.to_i
      if hum == 21
        puts "\nPlayer has #{hum}".brown
        puts "BLACKJACK".green
        evaluate_winner(hum)
        return
      elsif hum > 21
        fin_game(hum)
        @hit_request = "n"
      else
        puts "player has #{hum}".brown
        puts "HIT AGAIN?".brown
        @hit_request = gets.chomp
      end
    end
    evaluate_winner(hum)
  end

  def deal_computer
    @card3 = @ary.pop()
    @card4 = @ary.pop()
    @computer = House.new(@computer_name, 100, [@card3, @card4])
    puts "\nDealer Hand:".gray
    puts "Card One : ".gray + @computer.hand[0].value.to_s.gray + " of ".gray + @computer.hand[0].suit.gray
    puts "Card Two : ".gray + @computer.hand[1].value.to_s.gray + " of ".gray + @computer.hand[1].suit.gray
    tot = @computer.hand[0].value.to_i + @computer.hand[1].value.to_i
    puts "House has #{tot}".gray
    while tot < 16
      puts "House hits".gray
      tot += @ary.pop().value.to_i
      puts "House gets #{tot}".gray
      puts tot > 21 ? "DEALER BUST".red : next
    end
    return tot
  end

  def evaluate_winner(hum)
    @hit_request = "n"
    comp = deal_computer
    if comp > hum && comp < 22
      @player.bankroll -= 10
      @computer.bankroll += 10
      puts "\nYou lose".red
      puts "Remaining balance is #{@player.bankroll}"
    elsif comp == hum
      puts "TIE GAME- SPLIT".brown
      puts "Remaining balance is #{@player.bankroll}"
    else
      puts "\nYou Win!".green
      @player.bankroll += 10
      @computer.bankroll -= 10
      puts "Remaining balance is #{@player.bankroll}"
    end
    puts "\nNew Game? (y/n)".blue
    ans = gets.chomp
    p ans ? deal_player : exit
  end

  def fin_game(score)
    @hit_request = "n"
    @player.bankroll -= 10
    @computer.bankroll += 10
    puts "#{score}! \nYOU LOSE ".red
    puts "Remaining balance is #{@player.bankroll}"
    exit
  end
end

Game.new.new_game
