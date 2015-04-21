
//= require active_admin/base
//= require chosen-jquery
//= require s3_direct_upload
//= require nprogress.js
//= require turbolinks


function dom_onload() {
	$(".chosen-input").chosen({max_selected_options: 1 , search_contains: true , placeholder: "Select single..."});
	$(".multi-chosen-input").chosen({ search_contains: true , placeholder: "Select multiple..."});
	$("#footer p").html("<strong>AdminPanel</strong> for <a href='http://classcollab.com'>class colab</a> project")
}


$(document).on('ready', function() {
	dom_onload();
});

$(document).on('page:load', function() {
	dom_onload();
});

$(document).on('page:fetch',   function() { NProgress.start(); });
$(document).on('page:change',  function() { NProgress.done(); });
$(document).on('page:restore', function() { NProgress.remove(); });

