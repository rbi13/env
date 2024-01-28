#!/bin/sh
## web shortcuts
#

# google - search
wgg() {
    search_terms="$*"
    search_url="https://www.google.com/search?q=$search_terms"
    firefox "$search_url" &
    exit
}

# youtube - search
wyt() {
    search_terms="$*"
    search_url="https://www.youtube.com/results?search_query=$search_terms"
    firefox "$search_url" &
    exit
}

# amazon - search
wama() {
    search_terms="$*"
    search_url="https://www.amazon.ca/s?k=$search_terms"
    firefox "$search_url" &
    exit
}
wamo() {
    search_url="https://www.amazon.ca/gp/css/order-history?ref_=nav_orders_first"
    firefox "$search_url" &
    exit
}


