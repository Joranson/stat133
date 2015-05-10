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





































```
Error in file(con, "r") : cannot open the connection
```
