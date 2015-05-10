# Let's read data into R that is JSON formatted
# We will use the RJSONIO library
# It has a function fromJSON that converts JSON formatted data into an R list 
> library(RJSONIO)
> kiva = fromJSON("1.json")

# Let's examine the R object returned from the call
> names(kiva)
[1] "header"  "lenders"

> length(kiva$lenders)
[1] 1000

> kiva$lenders[[1]]
$lender_id
[1] "matt"
$name
[1] "Matt"
$image
$image$id
[1] 12829
$image$template_id
[1] 1
$whereabouts
[1] "San Francisco CA
$country_code
[1] "US"
$uid
[1] "matt"
$member_since
[1] "2006-01-01T09:01:01Z"
$personal_url
[1] "www.socialedge.org/blogs/kiva-chronicles"
$occupation
[1] "Entrepreneur"
$loan_because
[1] "I love the stories. "
$occupational_info
[1] "I co-founded a startup nonprofit (this one!) and I work with an amazing group of people dreaming up ways to alleviate poverty through personal lending. "
$loan_count
[1] 89
$invitee_count
[1] 23

# Check that it indeed a list
> class(kiva$lenders[[1]])
[1] "list"

# Look at the names of the elements of the first element in the list, the first lender
> names(kiva$lenders[[1]])
 [1] "lender_id"         "name"              "image"            
 [4] "whereabouts"       "country_code"      "uid"              
 [7] "member_since"      "personal_url"      "occupation"       
[10] "loan_because"      "occupational_info" "loan_count"       
[13] "invitee_count"  

# Let's try extracting the loan count from all 1000 lenders into a vector  
> loanCt = sapply(kiva$lenders, function(x) x[["loan_count"]])
> class(loanCt)
[1] "list"
> head(loanCt)
[[1]]
[1] 89

[[2]]
[1] 54

[[3]]
[1] 169

[[4]]
[1] 12

[[5]]
[1] 7

[[6]]
[1] 10

> length(loanCt)
[1] 1000
> max(sapply(loanCt, length))
[1] 1

> loanCt = unlist(loanCt)
> summary(loanCt)
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    1.0     7.0    15.0    45.8    34.0  3202.0 

