Text Data and Regular Expressions
========================================================
author: 
date: 

Text Data
=============================
Overview
- R functions for text data 
- Some motivating Examples
- Regular Expressions

R commands
=============================
To work with text data we need to
- read it into R
- work with character variables
- match strings and general string patterns
- search and replace strings
- study regular expressions

On the next few slides we list some R commands for these tasks.  Another good resource 
is [The R Programming Wikibook](http://en.wikibooks.org/wiki/R_Programming/Text_Processing)

Functions to read in/write to a textfile 
=============================

```r
readLines("filename.txt")
writeLines(string, "filename.txt")
scan("filename.txt", character(0))
read.csv()
read.table()
```

Character variables in R
=============================
Create an (empty) character vector

```r
str1 <- character()
str1
```

```
character(0)
```

```r
str2 <- character(5)
str2
```

```
[1] "" "" "" "" ""
```

Character variables in R
=============================
Check whether a variable is a character variable, or cast a variable as a character variable:

```r
is.character(str2)
```

```
[1] TRUE
```

```r
x <- 2
xchar <- as.character(x)
xchar
```

```
[1] "2"
```

String Manipulation in R
====================
Extract a portion of a character sting from text, beginning at first, ending at last
```text
substring(text, first, last) 
```
Split the string into pieces using "split"" to divide it 
```text
strsplit(x, split)
```
Splits into one character pieces
```text
strsplit(x, “”)
```

String Manipulation in R
====================
Paste together strings separated by one blank

```r
paste(x, y, z, …, sep = " ", collapse = NULL)
```
Return the number of characters in a string
```text
nchar(text)
```
convert upper-case char. to lower-case, or vice versa. Non-alphabetic characters are left unchanged
```text
tolower(x) 
toupper(x)
```


Functions which use regular expressions
=====================
To extract a value from a string variable

```r
grep()  #returns indices of matches
grepl() #returns logical vector
sub()
gsub()
```

Package stringr
=====================
If you install the package stringr you get access to more functions:

```r
ignore.case()
str_extract() 
str_detect()
str_replace()
str_dup()
```
Other specialized functions:

```r
splitByPattern() # in package R.utils
gsubfn()         # in packagegsubfn
```

Text Data - Motivation
=============================
We consider four examples.
- Election Study
- State of Union Addresses
- Web behaviour
- Email (spam filter)

Election Study
=============================


Election Study
=============================
We have the following data:
- Geographic Data – longitude and latitude of the county center
- Population Data from the census for each county
- Election results from 2008 for each county (scraped from a Website)

On the next slide you can see exerpts of each of these files (in the above order).

Notice that there is variation in how the county names are written.

Geographic / Population / Election Data
==========
```text
"De Witt County",IL,40169623,-88904690
"Lac qui Parle County",MN,45000955,-96175301
"Lewis and Clark County",MT,47113693,-112377040
"St John the Baptist Parish",LA,30118238,-90501892

"St. John the Baptist Parish","43,044","52.6",.
"De Witt County","16,798","97.8",...
"Lac qui Parle County","8,067","98.8",...
"Lewis and Clark County","55,716","95.2",...

DeWitt                23 23 4,920 2,836    0
Lac Qui Parle         31 31 2,093 2,390   36
Lewis & Clark         54 54 16,432 12,655 386
St. John the Baptist  35 35 9,039 10,305  74
```

Election results, different format
====================
```text
"countyName" "bushVote" "kerryVote"
"arizona,apache" 8068 15082
"arizona,cochise" 24828 16219
"arizona,coconino" 20619 26513
"arizona,gila" 10494 7107
"arizona,graham" 7302 3141
"arizona,greenlee" 1899 1146
"arizona,la paz" 3158 1849
"arizona,maricopa" 539776 403882
"arizona,mohave" 29608 16267
"arizona,navajo" 16474 14224
"arizona,pima" 138431 154291
"arizona,pinal" 34813 25652
"arizona,santa cruz" 4668 6909
```

Merging data from different sources
=============================
To combine the geographic, population and election data into one dataset we have to 
resolve how to match counties across sources.  Challenges arise from something as 
mundane as different spelling, capitalization, etc.

- Capitalization : qui vs Qui
- Spelling : DeWitt vs De Witt
- Punctuation : St. vs St  
- Missing Data : County/Parish missing

One example - Punctuation
=============================
A small problem
- County names in census file have no “.” after St, e.g. “St John”
- County names in geographic file do have the “.”, e.g. “St. John”
- Let’s find a way to update the county names in the census file to add the period after “St”

In R
===========================

```r
# Source these in to play with some regular expressions
cNames = c("Dewitt County", 
           "Lac qui Parle County", 
           "St John the Baptist Parish", 
           "Stone County")

test = cNames[3]
string = "The Slippery St Frances"
```

One possible solution
===========

```r
substring(test, 1, 2)
```

```
[1] "St"
```

```r
substring(test, 1, 2) == "St"
```

```
[1] TRUE
```

```r
newName = paste("St.", substring(test, 3, nchar(test)), sep = "")

newName
```

```
[1] "St. John the Baptist Parish"
```

Slight variation on this possible solution
===================

```r
substring(test, 1, 3)
```

```
[1] "St "
```

```r
substring(test, 1, 3)  ==  "St "
```

```
[1] TRUE
```

```r
newName = paste("St. ", substring(test, 4, nchar(test)), sep ="")
newName
```

```
[1] "St. John the Baptist Parish"
```

We can do this for every element in cNames
===========

```r
substring(cNames, 1, 2) == "St"
```

```
[1] FALSE FALSE  TRUE  TRUE
```

```r
substring(cNames, 1, 3)
```

```
[1] "Dew" "Lac" "St " "Sto"
```

```r
substring(cNames, 1, 3) == "St "
```

```
[1] FALSE FALSE  TRUE FALSE
```

===========

```r
newNames = cNames
whichRep = substring(cNames, 1, 3) == "St "
newNames[whichRep] = 
     paste("St. ", 
           substring(cNames[whichRep], 4, 
                     nchar(cNames[whichRep])), sep = "")
newNames
```

```
[1] "Dewitt County"               "Lac qui Parle County"       
[3] "St. John the Baptist Parish" "Stone County"               
```

Yet another idea
===========

```r
string = "The Slippery St Frances"
chars1 = unlist(strsplit(string, " "))
chars1
```

```
[1] "The"      "Slippery" "St"       "Frances" 
```

```r
chars = unlist(strsplit(string, ""))
chars
```

```
 [1] "T" "h" "e" " " "S" "l" "i" "p" "p" "e" "r" "y" " " "S" "t" " " "F"
[18] "r" "a" "n" "c" "e" "s"
```

Now find S
====================

```r
possible = which(chars == "S")
possible
```

```
[1]  5 14
```

```r
substring(string, possible, possible + 2)
```

```
[1] "Sli" "St "
```

```r
substring(string, possible, possible + 2) == "St "
```

```
[1] FALSE  TRUE
```

Final solution, use gsub
===========

```r
gsub("St ", "St. ", cNames)
```

```
[1] "Dewitt County"               "Lac qui Parle County"       
[3] "St. John the Baptist Parish" "Stone County"               
```

What were we doing?
======================

- Look at each character
- Check to see if it is “S”
- If it is, then look at the next character(s)

This is the idea behind regular expressions

Regular Expressions
=============================

The regular expression “St ” is made up of three literal characters.  The regular expression matching engine does something very similar to what we just did.

```text
         The Slippery St Frances
               ||       ||| 
Found S________||       |||
Followed by t?__| No    ||| 
Is it S?________| No ...||| Keep looking for S
Found S_________________|||
Followed by t?___________|| Yes
Followed by a blank?______| Yes - A match!
```

gsub in R
=============================

The R functions gsub() and sub() look for a pattern and replace it with some other text, 
leaving the rest of the string unchanged.

The “g” in gsub() refers to global.  It changes all the matches, whereas sub() only replaces the first 
match in each element.  Both gsub()  and sub are vectorized.

Text gsub
============
Spot the difference!

```r
strings = c("a test", "and one and one is two", "one two three")

gsub("one", "1", strings)
```

```
[1] "a test"             "and 1 and 1 is two" "1 two three"       
```

```r
sub("one", "1", strings)
```

```
[1] "a test"               "and 1 and one is two" "1 two three"         
```
Practice with : paste(), substring(), nchar(), strsplit()


Web behavior
=============================

Web behavior
=============================
Every time you visit a Web site, information is recorded about the visit: 
- the page visited, 
- date and time of visit
- browser used
- operating system
- IP address

Web log - two entries
=============================
```text
169.237.46.168 - - [26/Jan/2004:10:47:58 -0800] 
"GET /stat141/Winter04 HTTP/1.1" 301 328 
"http://anson.ucdavis.edu/courses/" 
"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)”
 
169.237.46.168 - - [26/Jan/2004:10:47:58 -0800] 
"GET /stat141/Winter04/ HTTP/1.1" 200 2585 
"http://anson.ucdavis.edu/courses/" 
"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"
```

Web log - structure
=============================
The information in the log has a lot of structure, for example the date always appears in square brackets. 

However, the information is not consistently separated by the same characters such as in a csv ﬁle, 
nor is it placed consistently in the same columns in the ﬁle.

Web log - questions
=============================
- How to extract the day of month, month, and year from the log entry?
- What features of the entry are useful?
- Date is between [ ]
- Day, month, year are separated by /
- Year is separated from time by :


Web log - Let's process one entry
=============================

```r
wl = '169.237.46.168 - - [26/Jan/2004:10:47:58 -0800] "GET /stat141/Winter04 HTTP/1.1" 301 328 "http://anson.ucdavis.edu/courses/" "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)'
wl
```

```
[1] "169.237.46.168 - - [26/Jan/2004:10:47:58 -0800] \"GET /stat141/Winter04 HTTP/1.1\" 301 328 \"http://anson.ucdavis.edu/courses/\" \"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)"
```

=============================
Let's split the string and create a vector with one character per element 

```r
wpieces = strsplit(wl, "")
wpieces
```

```
[[1]]
  [1] "1"  "6"  "9"  "."  "2"  "3"  "7"  "."  "4"  "6"  "."  "1"  "6"  "8" 
 [15] " "  "-"  " "  "-"  " "  "["  "2"  "6"  "/"  "J"  "a"  "n"  "/"  "2" 
 [29] "0"  "0"  "4"  ":"  "1"  "0"  ":"  "4"  "7"  ":"  "5"  "8"  " "  "-" 
 [43] "0"  "8"  "0"  "0"  "]"  " "  "\"" "G"  "E"  "T"  " "  "/"  "s"  "t" 
 [57] "a"  "t"  "1"  "4"  "1"  "/"  "W"  "i"  "n"  "t"  "e"  "r"  "0"  "4" 
 [71] " "  "H"  "T"  "T"  "P"  "/"  "1"  "."  "1"  "\"" " "  "3"  "0"  "1" 
 [85] " "  "3"  "2"  "8"  " "  "\"" "h"  "t"  "t"  "p"  ":"  "/"  "/"  "a" 
 [99] "n"  "s"  "o"  "n"  "."  "u"  "c"  "d"  "a"  "v"  "i"  "s"  "."  "e" 
[113] "d"  "u"  "/"  "c"  "o"  "u"  "r"  "s"  "e"  "s"  "/"  "\"" " "  "\""
[127] "M"  "o"  "z"  "i"  "l"  "l"  "a"  "/"  "4"  "."  "0"  " "  "("  "c" 
[141] "o"  "m"  "p"  "a"  "t"  "i"  "b"  "l"  "e"  ";"  " "  "M"  "S"  "I" 
[155] "E"  " "  "6"  "."  "0"  ";"  " "  "W"  "i"  "n"  "d"  "o"  "w"  "s" 
[169] " "  "N"  "T"  " "  "5"  "."  "0"  ";"  " "  "."  "N"  "E"  "T"  " " 
[183] "C"  "L"  "R"  " "  "1"  "."  "1"  "."  "4"  "3"  "2"  "2"  ")" 
```
Web log - Find Date
============================
We know the date and time are withing square brackets, search for them:

```r
beg = which(wpieces =="[")
end = which(wpieces == "]")
beg
```

```
integer(0)
```

```r
end
```

```
integer(0)
```
What happened?

============================
We forgot that wpieces is a list:

```r
class(wpieces)
```

```
[1] "list"
```

```r
wpieces
```

```
[[1]]
  [1] "1"  "6"  "9"  "."  "2"  "3"  "7"  "."  "4"  "6"  "."  "1"  "6"  "8" 
 [15] " "  "-"  " "  "-"  " "  "["  "2"  "6"  "/"  "J"  "a"  "n"  "/"  "2" 
 [29] "0"  "0"  "4"  ":"  "1"  "0"  ":"  "4"  "7"  ":"  "5"  "8"  " "  "-" 
 [43] "0"  "8"  "0"  "0"  "]"  " "  "\"" "G"  "E"  "T"  " "  "/"  "s"  "t" 
 [57] "a"  "t"  "1"  "4"  "1"  "/"  "W"  "i"  "n"  "t"  "e"  "r"  "0"  "4" 
 [71] " "  "H"  "T"  "T"  "P"  "/"  "1"  "."  "1"  "\"" " "  "3"  "0"  "1" 
 [85] " "  "3"  "2"  "8"  " "  "\"" "h"  "t"  "t"  "p"  ":"  "/"  "/"  "a" 
 [99] "n"  "s"  "o"  "n"  "."  "u"  "c"  "d"  "a"  "v"  "i"  "s"  "."  "e" 
[113] "d"  "u"  "/"  "c"  "o"  "u"  "r"  "s"  "e"  "s"  "/"  "\"" " "  "\""
[127] "M"  "o"  "z"  "i"  "l"  "l"  "a"  "/"  "4"  "."  "0"  " "  "("  "c" 
[141] "o"  "m"  "p"  "a"  "t"  "i"  "b"  "l"  "e"  ";"  " "  "M"  "S"  "I" 
[155] "E"  " "  "6"  "."  "0"  ";"  " "  "W"  "i"  "n"  "d"  "o"  "w"  "s" 
[169] " "  "N"  "T"  " "  "5"  "."  "0"  ";"  " "  "."  "N"  "E"  "T"  " " 
[183] "C"  "L"  "R"  " "  "1"  "."  "1"  "."  "4"  "3"  "2"  "2"  ")" 
```

============================
We need to pull the vector out of the list

```r
wpieces = strsplit(wl, "")[[1]]
beg = which(wpieces =="[")
end = which(wpieces == "]")
beg
```

```
[1] 20
```

```r
end
```

```
[1] 47
```

============================
If we add/subtract 1, we can get exactly the date:

```r
beg = which(wpieces =="[") + 1
end = which(wpieces == "]") - 1
wholeDate = substr(wl, beg, end)
wholeDate
```

```
[1] "26/Jan/2004:10:47:58 -0800"
```

================================
Now that we have the wholeDate, let us split it to remove the time

```r
notime = strsplit(wholeDate, ":")[[1]][1]
notime
```

```
[1] "26/Jan/2004"
```
Finally, to separate day, month and year we split on /

```r
datePieces = strsplit(notime, "/")
datePieces
```

```
[[1]]
[1] "26"   "Jan"  "2004"
```

Web log - the whole file
=============================

```r
fileLoc = "weblog.txt"
wl = readLines(fileLoc)
length(wl)
```

```
[1] 2
```

```r
class(wl)
```

```
[1] "character"
```

```r
wl
```

```
[1] "169.237.46.168 -- [26/Jan/2004:10:47:58 -0800] \"GET /stat141/Winter04 HTTP/1.1\" 301 328 \"http://anson.ucdavis.edu/courses/\" \"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)\""  
[2] "169.237.46.168 -- [26/Jan/2004:10:47:58 -0800] \"GET /stat141/Winter04/ HTTP/1.1\" 200 2585 \"http://anson.ucdavis.edu/courses/\" \"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)\""
```
Web log - make a dataframe
=============================
Suppose we want to make a data frame with the variables:
- ip address
- day of month
- month
- year
- operation (GET, PUt, etc)
- URL

Notice that the strucutre is such that we can pull out
pieces of information using regular expressions.
To begin we split on quotes and brackets.

============================

```r
wlist = strsplit(wl, " \"| -- \\[|\" ")
wlist[[1]]
```

```
[1] "169.237.46.168"                                                           
[2] "26/Jan/2004:10:47:58 -0800]"                                              
[3] "GET /stat141/Winter04 HTTP/1.1"                                           
[4] "301 328"                                                                  
[5] "http://anson.ucdavis.edu/courses/"                                        
[6] "\"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.1.4322)\""
```
We have done a good job of splitting up the pieces of the data.
Now let's use these pieces to create our variables

=============================== 
Some are easy, just pick off the particular elements in the list.

```r
ipAddr = sapply(wlist, function(x) x[1])
url = sapply(wlist, function(x) x[5])
ipAddr
```

```
[1] "169.237.46.168" "169.237.46.168"
```

```r
url
```

```
[1] "http://anson.ucdavis.edu/courses/" "http://anson.ucdavis.edu/courses/"
```

===============================
To get the operation, we can use gsub to eliminate
the unwanted stuff from the thrid element

```r
op = sapply(wlist, function(x) gsub(" .*$", "", x[3]))
op
```

```
[1] "GET" "GET"
```

===============================
To get the pieces of the date, we can use strsplit on the second element

```r
dates = sapply(wlist, function(x) strsplit(x[2], "/|:"))
dates
```

```
[[1]]
[1] "26"        "Jan"       "2004"      "10"        "47"        "58 -0800]"

[[2]]
[1] "26"        "Jan"       "2004"      "10"        "47"        "58 -0800]"
```

===============================
Here's another way to pick them out

```r
day = sapply(dates, "[", 1)
month = sapply(dates, "[", 2)
year = sapply(dates, "[", 3)
day
```

```
[1] "26" "26"
```

```r
month
```

```
[1] "Jan" "Jan"
```

```r
year
```

```
[1] "2004" "2004"
```

===============================
We can now put them all in a data frame

```r
wlDF = data.frame(ipAddr = ipAddr, day =day, month = month,
                  year = year, op = op, url = url)
wlDF
```

```
          ipAddr day month year  op                               url
1 169.237.46.168  26   Jan 2004 GET http://anson.ucdavis.edu/courses/
2 169.237.46.168  26   Jan 2004 GET http://anson.ucdavis.edu/courses/
```

Fixed Width Data
===============================
An alternative to regular expressions.

Note that the information appears in the same positionin the line for each log entry.
We can specify where to pull the variables from


```r
wl2 = read.fwf(fileLoc, widths = c(14,5,2,1,3,1,4,18,3))
wl2
```

```
              V1    V2 V3 V4  V5 V6   V7                 V8  V9
1 169.237.46.168  -- [ 26  / Jan  / 2004 :10:47:58 -0800] " GET
2 169.237.46.168  -- [ 26  / Jan  / 2004 :10:47:58 -0800] " GET
```

==============================
Now extract the entries we want

```r
wlDF2 = wl2[ , c(1, 3, 5, 7, 9)]
names(wlDF2) = c("ipAddr", "day", "month", "year", "op")
wlDF2
```

```
          ipAddr day month year  op
1 169.237.46.168  26   Jan 2004 GET
2 169.237.46.168  26   Jan 2004 GET
```
Notice that this isn't going to work for hte URL 
because they could be of different lengths

Regular Expressions
=======================
Regular expressions give us a powerful way of matching patterns in text data.

Most importantly, we do this all programatically rather than by hand, so that 
we can easily reproduce our work if needed.

Many programming languages support the use of regular expressions.

Reference : [Wiki page](http://en.wikipedia.org/wiki/Regular_expression)

Regular Expressions
=============================
A regular expression (aka regex or regexp) is 
_a sequence of characters that forms a search pattern_.

Or : _A pattern that describes a set of strings._

This set of patterns may be finite or infinite, depending on the particular regexp. 

Regular Expressions - matching
============================
We say the regexp “matches” each element of that set. 

For example, the regexp 
```text
grey|gray 
```
matches both grey and gray, whereas 

```text 
^A.* 
```
matches any string starting with capital A.

Regular Expressions
=============================
With regular expressions, we can
- extract pieces of text 
– e.g., find all links in an HTML document
- create variables from information found in text
- clean and transform text into a uniform format, 
- resolve inconsistencies in format between files
- mine text by treating documents directly as data
- “scrape” the web for data

Syntax
==================================
Literal characters are matched only by the character itself.

A character class is matched by any single member of the specified class.  For example,
```text
[A-Z] 
```
is matched by any capital letter.

Modifiers operate on literal characters, character classes, or combinations of the two. 
For example ^ is an anchor that indicates the literal must appear at the beginning of the string

Warning
=============================
The syntax for regexps is extremely concise

It can be overwhelming if you try to read it like you would regular text.  

Always break it down into these three components: 
- literals
- character classes
- modifiers

Example 
=======================
- How to find fake words like rep1!c@ted?

- What makes this different from a regular word?

- Numbers and punctuation surrounded by letters

- Concepts of “numbers”, “punctuation”, and “regular letters” get at the idea 
of equivalent characters or character classes.

Equivalent Characters
=============================
We can enumerate any collection of characters within [ ].  
Example: [Tt]his

The character “-” when used within the character class pattern identifies a range.  
Examples: 
```text
[0-9], [A-Za-z]
```

Compliment of Equivalent Characters
=============================
If we put a caret 
```text
^
```
as the first character , this indicates that the equivalent 
characters are the complement of the enumerated characters. 
Example: 
```text
[^0-9]
```

Equivalent Characters
=============================
If we want to include the character “-” in the set of characters to match, 
put it at the beginning of the character set to avoid confusion.  Example: [-+][0-9]

Note that here we have created a pattern from a sequence of two sub-patterns.

Named Equivalence Classes
=============================
These can be used in conjunction with other characters, for example [[:digit:]_]


Return to rep1!c@ted  
====================
What will this match?
```text
[[:alpha:]][[:digit:][:punct:]][[:alpha:]]
```
Note that digit and punct are together within an outer []

Can you foresee any problems with it?
=============================

Functions that use Regular Expressions
=============================
Look for the regular expression in pattern in the character string(s) in x, returns the indices of the elements for which there was a match:
```text
grep(pattern, x)  
```
Look the regular expression in pattern in x and replace the  matching characters with replacement (all occurrences) sub() works the same way but only replaces the first occurrence.
```text
gsub(pattern, replacement, x) 
```

Functions that use Regular Expressions
=============================
```text
regexpr(pattern, text) 
```
returns an integer vector giving the starting position of the first match or -1 if there is none. 

The return value has an attribute "match.length", that gives the length of the matched text (or -1 for no match). 

```text
gregexpr(pattern,text)
```
Returns the locations of all occurrences of the pattern in each element of text.  The return is a list.

R Example
=====================

```r
subjectLines = c("Re: 90 days", "Fancy rep1!c@ted watches", "It's me")
subjectLines
```

```
[1] "Re: 90 days"              "Fancy rep1!c@ted watches"
[3] "It's me"                 
```

```r
grep("[[:alpha:]][[:digit:][:punct:]][[:alpha:]]", subjectLines)
```

```
[1] 2 3
```

R Example
====================
We can either remove the apostrophe first:

```r
newString = gsub("'", "", subjectLines)
grep("[[:alpha:]][[:digit:][:punct:]][[:alpha:]]",   newString)
```

```
[1] 2
```

Or we can specify the particular punctuation marks we’re looking for:

```r
grep("[[:alpha:]][[:digit:]!@#$%^&*():;?,.][[:alpha:]]", subjectLines)
```

```
[1] 2
```

R Example
====================
gregexpr() shows exactly where the pattern was found:

```r
newString = c("Re: 90 days", "Fancy rep1!c@ted watches", "Its me")                 
gregexpr("[[:alpha:]][[:digit:][:punct:]][[:alpha:]]", newString)
```

```
[[1]]
[1] -1
attr(,"match.length")
[1] -1
attr(,"useBytes")
[1] TRUE

[[2]]
[1] 12
attr(,"match.length")
[1] 3
attr(,"useBytes")
[1] TRUE

[[3]]
[1] -1
attr(,"match.length")
[1] -1
attr(,"useBytes")
[1] TRUE
```

R Example
============================
We didn’t find p1!c because it consists of four characters: a letter, a digit, a punctuation mark, and another letter.

To search for the more general pattern of any number of digits or punctuation marks between letters, we use

[[:alpha:]][[:digit:][:punct:]]+[[:alpha:]]

The plus sign indicates that members from the second character class (digits and punctuation) may appear one or more times.

The plus sign is an example of a meta character.

Meta characters
=============================
Meta characters that control how many times something is repeated

The position of a character in a pattern determines whether it is treated as a meta character.

Examples: [-+*/], [1-9]*

R quirk
======================
When you want to refer to one of these symbols literally, you need to precede it with a backslash (\).  However, this  already has a special meaning in R’s character strings -- it’s used to indicate control characters like newline (\n).

So, to refer to these symbols in R’s regular expressions, you need to precede them with two backslashes.

Meta Characters
=============================
The characters for which you need to do this are:
. ^ $ + ? ( ) [ ] { } | \

Practice: Indicate which strings contain a match to the pattern
More Practice: Write a regular expression that matches

1. only the words “cat”, “at”, and “t”

2. The words “cat”, “caat”, “caaat”, and so on

3. “dog”, “Dog”, “dOg”, “doG”, “DOg”, etc. (i.e., the word dog in any combination of upper and lower case) anywhere in the string

4. Any number, with or without a decimal point

Greedy Matching
=============================
Be careful with patterns matching too much. 
The matching is greedy in that it matches as much as possible
For example: when trying to remove HTML tags from a document, the regular expression
```text
  <.*> 
```
will match too much but the regular expression  
```text
<[^>]*>
```
will be just right.  Why?

Spam filtering: Anatomy of email message
=============================
Three parts of an email:
- header 
- body 
- attachments (optional)

Like regular mail, the header is the envelope and the body is the letter.  

The data is stored as plain text.

Email Anatomy
===================
Header
- date, sender, and subject 
- message id
- who are the carbon-copy recipients
- return path

SYNTAX –  KEY:VALUE

Example header
===================

```r
Date: Mon, 2 Feb 2004 22:16:19 -0800 (PST) 
From: nolan@stat.Berkeley.EDU 
X-X-Sender: nolan@kestrel.Berkeley.EDU 
To: Txxxx Uxxx <txxxx@uclink.berkeley.edu> 
Subject: Re: prof: did you receive my hw? 
In-Reply-To: <web-569552@calmail-st.berkeley.edu> 
Message-ID: <Pine.SOL.4.50.0402022216120.2296-100000@kestrel.Berkeley.EDU> 
References: <web-569552@calmail-st.berkeley.edu> 
MIME-Version: 1.0 
Content-Type: TEXT/PLAIN; charset=US-ASCII 
Status: O 
X-Status: 
X-Keywords: 
X-UID: 9079
```

Email
==================
Body is separated from the header by a single blank line. 
Attachment is included in the body of the message. 
To figure out what part of the body is the message and what part is an attachment mail 
programs use an Internet standard called MIME, Multipurpose Internet Mail Extensions. 

```text
Content-Type: has value multipart when attachments are present
Content-Type: MULTIPART/Mixed;
 BOUNDARY="_===669732====calmail-me.berkeley.edu===_” 

Boundary key provides a special character string to mark the beginning and end of the message parts. 
The last component of the message is followed by a line containing the boundary string with two hyphens at the front and end of the string:
--_===669732====calmail-me.berkeley.edu===_-- 
```

What characteristics can you derive from the email?
=============================
- Sent in the early morning:
- Numeric 00 – 24 hour received
- Has an Re: in the subject line
- Logical: TRUE if Re: in subject line
- Funny words like v!@gra
- Logical: TRUE if punctuation in the middle of word
- Lots of YELLING IN THE EMAIL
- Numeric: proportion of characters that are capitals




In R - New example
===========================

```r
funny = "rep1!c@ted"
subjectLines = c("Re: 90 days", "Fancy rep1!c@ted watches", "It's me")

strings = c("hi mabc", "abc", "abcd", "abccd",
            "abcabcdx", "cab", "abd", "cad")

htmlStr = "<html><head></head><body> <h1>This is a title</h1><para>And this is a short paragraph. It has two sentences.</para></body></html>"
```

===========

```r
grep("[[:alpha:]][[:digit:][:punct:]][[:alpha:]]", 
     subjectLines)
```

```
[1] 2 3
```

```r
newStrings = gsub("'", "", subjectLines)
newStrings
```

```
[1] "Re: 90 days"              "Fancy rep1!c@ted watches"
[3] "Its me"                  
```

===========

```r
grep("[[:alpha:]][[:digit:][:punct:]][[:alpha:]]", 
     newStrings)
```

```
[1] 2
```

```r
gregexpr("[[:alpha:]][[:digit:][:punct:]][[:alpha:]]", 
     newStrings)
```

```
[[1]]
[1] -1
attr(,"match.length")
[1] -1
attr(,"useBytes")
[1] TRUE

[[2]]
[1] 12
attr(,"match.length")
[1] 3
attr(,"useBytes")
[1] TRUE

[[3]]
[1] -1
attr(,"match.length")
[1] -1
attr(,"useBytes")
[1] TRUE
```

```r
#[1] -1 12 -1
#attr(,"match.length")
#[1] -1  3 -1
#attr(,"useBytes")
#[1] TRUE
```

==========

```r
gregexpr("[[:alpha:]][[:digit:][:punct:]]+[[:alpha:]]",
         newStrings)
```

```
[[1]]
[1] -1
attr(,"match.length")
[1] -1
attr(,"useBytes")
[1] TRUE

[[2]]
[1] 9
attr(,"match.length")
[1] 4
attr(,"useBytes")
[1] TRUE

[[3]]
[1] -1
attr(,"match.length")
[1] -1
attr(,"useBytes")
[1] TRUE
```

```r
#[1] -1 9 -1
#attr(,"match.length")
#[1] -1  4 -1
#attr(,"useBytes")
#[1] TRUE
```



Text mining (State of Union Addresses)
=============================
- How long are the speeches?  
- How do the distributions of certain words change over time?  
- Which presidents have given “similar” speeches?

File with Speeches : stateoftheunion1790-2012.txt

State of Union Addresses - Start of file
=============================
\*** 

State of the Union Address 
George Washington 
December 8, 1790 

Fellow-Citizens of the Senate and House of Representatives: 
In meeting you again I feel much satisfaction in being able to repeat my 
congratulations on the favorable prospects which continue to distinguish 
our public affairs. The abundant fruits of another year have blessed our 
country with plenty and with the means of a flourishing commerce.


Text mining State of Union Addresses
=============================
- All speeches in one large plain text file
- Each speech starts with “***” on a line followed by 3 lines of information about who gave the speech and when
- To mine the speeches, we want to create a word vector for each speech, which tracks the counts of how many times a particular word was said in each speech.
- Words such as nation, national, nations should collapse to the same “word”


