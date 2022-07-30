export let modalHook = {
    mounted() {
        console.log("modals mounted");
        // this.handleEvent("close_modals", (modal) => close_modals(modal));
        this.handleEvent("open_modals", (modal) => open_modals(modal));
        this.handleEvent("display_modals", (modal) => display_modals(modal));
    }
}

// function close_modals(modal) {
//     console.log(modal)
//     modal = modal.modal
//     $("#" + modal).modal("hide")
//
//     // $("#"+modal).data('modal', null);
//     // // $('.modal').each(function () {
//     // //     $(this).modal('show');
//     // // });
//     // $('.modal-backdrop').remove()
// }

function display_modals(modal) {
    modal = modal.modal
    window.$("#" + modal).addClass("show");
    window.$("#" + modal).css("overflow-y", "auto")
    window.$("#" + modal).css({"display": "block"});
}

function open_modals(mod_name) {
    mod_name = mod_name.modal
    $("#" + mod_name).addClass('show');
}