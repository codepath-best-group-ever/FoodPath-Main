#  FoodPath

- for getFoodForAPI/getFoodFromML   -> should we only store the selected food from users? can act as a history checker + as a future feature;
- clean up database
- session clean up -> ischecked field reset

## updates:
- add duplicate checkmark handling 
- add checkmark index memory handling, to not disappear on scroll
- check ingredient via indexpath.row and not label 
- used different api for food dish search
    1. to not exhaust the serpapi 
    2. better results
