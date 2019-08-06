# Amin Babar
# 11/04/18
# Version: perl 5, version 16, subversion 3 (v5.16.3)
# This program takes an input file with no punctutation or no new line characters
# and it implements the word_check and the word_counter functions on these
# input files. An input dictionary is required for the word_check function to
# operate properly. The word_check function will tell the user of all the
# wrong inputs and replace those inputs with the next asked input.


#!/usr/bin/perl
use strict;
use warnings; 
use File::Slurp;

# reads the given dictionary into an array called @dictionary and the given
# input file into an array called @input_file

my @dictionary = read_file("words1.txt", chomp => 1);

my @input_file = [];

open FILE, "<", "text.txt" or die "unable to open input.txt $!";
while (<FILE>) 
{ 
   @input_file = split(' ', $_); 
} 

close(FILE);

my $dictionary_length = scalar @dictionary;

my @new_input_file = [];

sub replace_incorrect_words {
  # replaces each incorrect word by asking for user input
  foreach my $input_word (@input_file) {

    my $i = 0;

    # if the word is in the dictionary, its added to the new input file array
    foreach my $dict_word (@dictionary) {
      if (lc $input_word eq $dict_word) {
        push @new_input_file, $input_word;
        last;
      }
      $i += 1;

      # if the word is not found in the dictionary, the user is shown the
      # possible words, and is asked to replace the input word.
      if ($i == $dictionary_length) {
        print "$input_word is incorrect. Please enter a replacement for the word. Word possibilities are as following: \n";
        my @possible_words = word_check($input_word);

        foreach (@possible_words) {
          print "$_\n";
        }

        chomp (my $new_word = <STDIN>);
        push @new_input_file, $new_word;

      }
    }
  }

  shift @new_input_file;
  change_input_file();
}


sub word_check {
  # This subroutine finds all the words in the given dictionary that are one
  # letter apart compared to the input word.

  # An array containing all the possible words  
  my $incorrect_word = $_[0];
  my @possible_words = [];

  # for all the words in a dictionary of the same length as the incorrect word,
  # it compares each char in the incorrect word to the chars in the word from
  # the dictionary. If there is only a difference of one char in between the
  # two words, it adds that word to the list of possible words.
  foreach my $word (@dictionary) {
    my $i = 0;
    my $incorrect_chars = 0;

    if (length($incorrect_word) == length ($word)) {

      foreach my $char (split (//, $incorrect_word)) {
        if ($char ne substr($word, $i, 1)) {
          $incorrect_chars += 1;
        }

        $i += 1;

        if ($incorrect_chars > 1) {
          last;
        }

        elsif (($i) == length($incorrect_word)) {
          push @possible_words, $word;
        }

      }
    }
  }
  shift @possible_words;
  return @possible_words;
}


sub change_input_file {
  # makes edits to the input file. Separates each word by a space.
  my $string = "";
  foreach my $word (@new_input_file) {
    $string = $string . $word . " ";
  }

  open(my $fh, '>', 'text.txt') or die "Could not open file";
  print $fh "$string";
  close $fh;

}

sub word_counter {
  # Counts the user input word in the file. Prints the total number of that words.
  print "Input the word you would like to know the count of: \n";
  chomp (my $word_input = <STDIN>);
  my $i = 0;
  foreach my $word (@input_file) {
    if ($word_input eq $word) {
      $i += 1;
    }
  }
  print "$word_input was found $i many times in the given input file \n";
}



