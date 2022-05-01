library(tidyverse)
library(data.table)

str_c("prefix",c("a","b","ccc"),"suffix")

x <- c("Apple","Pear","Peach")
str_sub(x, 2, 4) <- str_to_lower(str_sub(x, 1, 1))
x
#> [1] "apple"  "banana" "pear"

# Exercise 14.1.1

## When passing a single vector, paste0 and paste work like as.character.
paste0(1:12)
paste(1:12)        # same
as.character(1:12) # same

## If you pass several vectors to paste0, they are concatenated in a
## vectorized way.
(nth <- paste0(1:12, c("st", "nd", "rd", rep("th", 9))))

## paste works the same, but separates each input with a space.
## Notice that the recycling rules make every input as long as the longest input.
paste(month.abb, "is the", nth, "month of the year.")
paste(month.abb, letters)

## You can change the separator by passing a sep argument
## which can be multiple characters.
paste(month.abb, "is the", nth, "month of the year.", sep = "_*_")

## To collapse the output into a single string, pass a collapse argument.
paste0(nth, collapse = ", ")

## For inputs of length 1, use the sep argument rather than collapse
paste("1st", "2nd", "3rd", collapse = ", ") # probably not what you wanted
paste("1st", "2nd", "3rd", sep = ", ")
paste(c("1st","2nd","3rd"))
paste(c("1st","2nd","3rd"),collapse = ", ")
paste(c("1st","2nd","3rd"),"4th",sep = ", ")
## You can combine the sep and collapse arguments together.
paste(month.abb, nth)
paste(month.abb, nth, collapse = "; ")
paste(month.abb, nth, sep = ": ")
paste(month.abb, nth, sep = ": ", collapse = "; ")

## Using paste() in combination with strwrap() can be useful
## for dealing with long strings.
(title <- paste(strwrap(
  "Stopping distance of cars (ft) vs. speed (mph) from Ezekiel (1930)",
  width = 30), collapse = "\n"))
plot(dist ~ speed, cars, main = title)

## 'recycle0 = TRUE' allows more vectorized behaviour, i.e. zero-length recycling :
valid <- FALSE
val <- pi
val[valid]
paste("the value is", 0.0 ," not so good")
paste("The value is", val[valid], "-- not so good!")
paste("The value is", val[valid], "-- good: empty!", recycle0=TRUE) # -> character(0)
## When  'collapse = <string>',  the result is a length-1 string :
paste("foo", {}, "bar", collapse="|")                  # |-->  "foo  bar"
paste("foo", {}, "bar", collapse="|", recycle0 = TRUE) # |-->  ""
## all empty args
paste(	  collapse="|")                  # |-->  ""  as do all these:
paste(	  collapse="|", recycle0 = TRUE)
paste({}, collapse="|")
paste({}, collapse="|", recycle0 = TRUE)

vect <- c("Q","R","S")
paste(c("a","b","c"),NA)
paste("a","b","c",NA, sep = "::")
paste0(c("a","b","c"),NA)
paste0("a","b","c",NA)

str_c(c("A","B","C"))
str_c(c("A","B","C"),collapse = "::")
str_c(c("A","B","C"),sep = "::")

str_c("A","B","C")
str_c("A","B","C",collapse = "::")
str_c("A","B","C",sep = "::")

str_c(vect,c("A","B","C"))
str_c(vect,c("A","B","C"),collapse = "::")
str_c(vect,c("A","B","C"),sep = "::")

str_c(vect,"A","B","C")
str_c(vect,"A","B","C",collapse = "::")
str_c(vect,"A","B","C",sep = "::")

# In paste and paste0, NA is not contagious - in str_c it is
# meaning anything concatenated with NA is wiped out, and only the NA is printed

# Exercise 14.2.5.2
# In your own words, describe the difference between the sep and collapse arguments to str_c()

# str_c concatenates stuff into a single string, by default with no spaces between elements
# if you pass str_c a vector, that's technically only one thing, so there's nothing to concatenate that to-
# it will print as its separate elements

# collapse will operate after str_c concatenates its elements - it then takes that output, if there are 
# still separate strings left (because of vectors) and make the output a single string, with a separator between
# the elements it receives after str_c concatenation

# sep merely adds a sep string between elements that are being concatenated by str_c

# collapse occurs after concatenation, whereas sep occurs during

# Exercise 14.2.5.3

test_string = "cactus"
str_sub(test_string,str_length(test_string)/2,str_length(test_string)/2)
str_sub(test_string,3,3)

# Exercise 14.2.5.4

thanks_path <- file.path(R.home("doc"), "THANKS")
thanks <- str_c(readLines(thanks_path), collapse = "\n")
thanks <- word(thanks, 1, 3, fixed("\n\n"))
cat(str_wrap(thanks), "\n")
cat(str_wrap(thanks, width = 40), "\n")
cat(str_wrap(thanks, width = 60, indent = 2), "\n")
cat(str_wrap(thanks, width = 60, exdent = 2), "\n")
cat(str_wrap(thanks, width = 0, exdent = 2), "\n")

sentences

x <- c("apple", "banana", "pear")
str_view(x, "an")
testingasdf <- "\\"
writeLines(testingasdf)

# Exercise 14.3.1.2
testing = "\"'\\\\"
testing
writeLines(testing)
x <- "\"'\\"
x
writeLines(x)
str_view(x,testing)

test2 <- "\\"
test2
writeLines(test2)

# Exercise 14.3.1.3
# \..\..\.. matches a literal period, any character, a literal period, any character, a literal period, and any character

test3 <- ".A.d.3"
test3
regex3 <- "\\..\\..\\.."
str_view(test3,regex3)


# find words for the spelling bee
library(words)
words::words

big_bucket <- filter(words::words,word_length>3)

letter_set <- "nadgoid"
must_use <- "g"


big_bucket <- mutate(big_bucket,center_letter = str_detect(word,must_use)) %>%
  filter(center_letter == TRUE)


results = c("found_words")

for (f in 1:nrow(big_bucket)) {
  this_word = big_bucket$word[f]
  reduced <- unique(unlist(str_split(this_word,"")))
  
    if (sum(str_detect(letter_set,reduced,negate = TRUE)) == 0 ) {
    # add this to the list of matching words
      results = c(results,this_word)
    }
}

results

testing <- str_detect(words, "^[^aeiou]+$")
testing
str_view(words$word, "^[^aeiouy]+$",match = TRUE)
testing

zzz <- "a|b|c|d" %>% 
  str_split("\\|") %>% 
  .[1][[1]]

words

words::words

big_words <- words::words$word

big_words

str_subset(big_words,"([aeiou])([^\\1a-df-hj-np-tv-z])([^\\1\\2a-df-hj-np-tv-z])([^\\1\\2\\3a-df-hj-np-tv-z])([^\\1\\2\\3\\4a-df-hj-np-tv-z])")
str_subset(big_words,"([aeiou])([^\\1a-df-hj-np-tv-z])([^\\1\\2a-df-hj-np-tv-z])([^\1\2\3a-df-hj-np-tv-z])([^\1\2\3\4a-df-hj-np-tv-z])")
a_set <- str_subset(big_words,"(^a[b-z]*$)|(^[b-z]+a[b-z]+$)|(^[b-z]+a$)")
a_set
#now take a_set and subset those with an e
e_set <- str_subset(big_words,"(^e[^e]*$)|(^[a-df-z]+e[a-df-z]+$)|(^[a-df-z]+e$)")
str_count(a_set,"e")
max(str_count(a_set,"e"))
e_set <- a_set[str_count(a_set,"e") == 1]
e_set
i_set <- e_set[str_count(e_set,"i") == 1]
i_set
o_set <- i_set[str_count(i_set,"o") == 1]
o_set
u_set <- o_set[str_count(o_set,"u") == 1]
u_set
y_set <- u_set[str_count(u_set,"y") == 1]
y_set
