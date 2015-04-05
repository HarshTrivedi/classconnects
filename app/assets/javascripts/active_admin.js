
//= require active_admin/base
//= require chosen-jquery
//= require s3_direct_upload


$(document).ready(function(){
	$(".chosen-input").chosen({max_selected_options: 1 , search_contains: true , placeholder: "Select single..."});
	$(".multi-chosen-input").chosen({ search_contains: true , placeholder: "Select multiple..."});
	$("#footer p").html("<strong>AdminPanel</strong> for <a href='http://classcolab.com'>class colab</a> project")
});

