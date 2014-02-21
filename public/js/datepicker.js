$(function() {
    $( ".datepicker" ).datepicker();
    $( ".datepicker" ).datepicker("option", "dateFormat", "yy-mm-dd");
});
$('.dropdown-toggle').dropdown()
$("#first_menu li").on('click',function () {
    var selectedOption = $(this).attr('data-value');
    $("#expiry_month").val(selectedOption);
    alert( $("#expiry_month").val());
});