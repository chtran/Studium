class Studium.Views.ApplicationUserModal extends Trunk.Views
  controller: "application"
  action: "userModal"

  render: ->
    f = this.functions
    $(".trigger").click(f.show_modal)
