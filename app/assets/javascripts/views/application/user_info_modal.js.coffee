class Studium.Views.ApplicationUserModal extends Trunk.Views
  controller: "application"
  action: "userModal"

  render: ->
    f = this.functions
    $(".modal-trigger").click(f.show_modal)
