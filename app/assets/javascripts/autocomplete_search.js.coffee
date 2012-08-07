$(->
  # Autocompletion for friend-search
  $(".search-friend").autocomplete
    source: $(".search-friend").data("autocomplete-source"),
    html: true,
    select: (event,ui) ->
       window.location=$(ui.item.label).find("a:first").attr("href")
)
