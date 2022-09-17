export let datepickerHook = {
    mounted() {
        console.log("Date Picker Mounted");
        this.handleEvent("setup_dates", params => setup_dates(params.data));
    }
}

function setup_dates(data){
    console.log(data)
    console.log( $("#date_picker_custom"))
    var excludeDays = data.excluded_dates;
    console.log(excludeDays)

    function disableSpecificDate(date) {
        // To disable specific day
        var dateArr = [String(date.getFullYear()), String(date.getMonth() + 1), String(date.getDate())];
        if (dateArr[1].length == 1) dateArr[1] = "0" + dateArr[1];
        if (dateArr[2].length == 1) dateArr[2] = "0" + dateArr[2];
        return excludeDays.indexOf(dateArr.join("-")) == -1;
    }
    $("#date_picker_custom").datepicker({
        dateFormat: 'dd/mm/yy',
        minDate: +1,
        maxDate: '+2M',
        beforeShow: function () {
            // To exclude next business day after 12 PM
            if (new Date().getHours() >= 12) {
                $(this).datepicker("option", "minDate", +2);
            }
        },
        beforeShowDay: function (date) {
            var day = date.getDay();
            return [(day == 0 ? false : disableSpecificDate(date)), ''];
        }
    });
}