# buyandsell

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.



## TODOs:

    - While adding new item, check Auth status
    - while opening new account, check if the user already exists, show snackbar
    - while opening new account, data may not get updated in userstack collection, notjing can be done
    - while opening new account, data may not get updated in users, so in profile page edit check if the user is in users collection, if not add new user to users collection.
    Show snackbar to add whatsapp number and Name in profile page
    - Multiple cards of the same thing showing up, either make persistanceEnabled false or check if this is being caused by addition to the list in the same session, if so, empty the list before adding new items each time.
    - Add a search bar in the home page
    - Add demand page



## RULES:
    Categories: //in firebase, all lowercase
        1. Books
        2. Electronics
        3. Decors
        4. Textile
        5. Cycle
        6. Households
        7. Sports
        8. Miscellaneous
        All

    State variable:
        [-1 for error]
        0 for available,
        1 for booked,
        2 for sold
    for used_condition: [condition]
        5 for brand new, unused
        4 for like new, excellent
        3 for good
        2 for fair
        1 for old but usable
        [0 for error]
    for used_for: [usage]
        [-3 for error]
        -2 used once or twice
        -1 for less than a week
        0 for unused
        1 for less than a month
        2 for less than 2 months
        3 for less than 3 months
        4 for less than 6 months
        5 for less than a year
        6 for less than 2 years
        7 for 3 years
        8 for 4 years
        9 for 5 years
        10 for more than 5 years


Note: For pictures, under each uid, the images will be uploaded to a folder of name of the doc id of the item, then image1 to image4.
Note: editable fields in profile: name, whatsapp
Note: editable fields in item listing: description, sp, state, negotiability,
    location, item_count, other_price, other_store, store_link, category.



