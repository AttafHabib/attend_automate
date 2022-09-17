export let modalHook = {
    mounted() {
        console.log("modals mounted");
        this.handleEvent("close_modals", (modal) => close_modals(modal));
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

// function display_modals(modal) {
//     modal = modal.modal
//     window.$("#" + modal).addClass("show");
//     window.$("#" + modal).css("overflow-y", "auto")
//     window.$("#" + modal).css({"display": "block"});
// }
//
// function open_modals(modal) {
//     console.log(modal)
// //
// //     modal = modal.modal
// //     window.$("#"+modal).modal(opts)
// //     if (modal == "add_blocks" || modal == "deletepopup")
// //     {window.$(".modal-backdrop.show").css("opacity", 0)}
//     modal = modal.modal
//     // $("#" + modal).addClass('show');
//     $("#" + modal).modal(opts)
// }


function close_modals(modal) {
    //console.log(modal)
    modal = modal.modal
    window.$("#"+modal).modal("hide")

}
function open_modals(modal) {

    console.log(modal)

    modal = modal.modal
    // $('#'+modal+'-form').submit(function(e) {
    //     window.$("#"+modal).modal("hide");
    // });
    // $('#'+modal+'-form1').submit(function(e) {
    //     window.$("#"+modal).modal("hide");
    //     $(".loading_container").attr("style", "display: flex !important;")
    // });
    // $('#'+modal+'-form2').submit(function(e) {
    //     window.$("#"+modal).modal("hide");
    //     $(".loading_container").attr("style", "display: flex !important;")
    //     $("div.processing_txt").attr("style", "display: flex !important; position: absolute; margin-top: 120px; text-align: center; font-size: 20px; font-weight: bold;")
    // });

    window.$("#"+modal).css("overflow-y", "auto")
    let opts;
    const popup_modals = [];
    if(popup_modals.includes(modal)){
        opts = {backdrop: 'static'}
    }else{
        opts = {backdrop: true}
    }
    window.$("#"+modal).modal(opts)
    // if (modal == "add_blocks" || modal == "deletepopup")
    // {window.$(".modal-backdrop.show").css("opacity", 0)}
}
function display_modals(modal) {
    console.log("Display")
    modal = modal.modal
    console.log(modal)
    window.$("#"+modal).addClass("show");
    window.$("#"+modal).css("overflow-y", "auto")
    window.$("#"+modal).css({"display": "block"});
    if(modal == "addguest"){
        $('.searchexp .search_bar').focus();
    }
}
// function hide_loading(modal) {
//     let file_progress = $("#file_progress_percent")[0]
//     if(file_progress){
//         file_progress.classList.add("d-none")
//     }
//     $(".loading_container").attr("style", "display: none !important")
// }
// function show_alerts(data) {
//     //console.log(data)
//     alert(data.msg)
// }
// function emails(data) {
//     window.location.href = "mailto:"+data.emails.join(",");
// }
