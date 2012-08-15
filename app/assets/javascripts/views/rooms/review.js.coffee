class Studium.Views.RoomsReview extends Trunk.Views
  controller: "rooms"
  action: "review"
  render: ->
    $(".selected").addClass("btn-danger")
                  .append("<div class='span2'>Your choice</div>")
    $(".correct").addClass("btn-success")
                 .append("<div class='span2'><i class='icon-white icon-ok' /></div>")
    $(".paragraph .show_paragraph").live("click", ->
      $(this).siblings(".paragraph-content").show()
      $(this).removeClass("show_paragraph").addClass("hide_paragraph").text("Hide paragraph")
    )
    $(".paragraph .hide_paragraph").live("click", ->
      $(this).siblings(".paragraph-content").hide()
      $(this).removeClass("hide_paragraph").addClass("show_paragraph").text("Show paragraph")
    )

