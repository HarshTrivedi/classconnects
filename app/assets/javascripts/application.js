// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery-ui/autocomplete
//= require turbolinks
//= require retina.js
//= require demo-panel.js
//= require bootstrap_002.js

//= require toastr
//= require chosen-jquery
//= require s3_direct_upload

//= require jquery_validator.js






function main_college_search_autocomplete() {

    $('#main_college_search_autocomplete').autocomplete({
            minLength: 1,
			delay: 300 ,
            source: function(request, response) {
	            $.ajax({
	                url: "/colleges/autocomplete_elements.json",
	                dataType: "json",
	                data: {
	                    term : request.term
	                },
	                success: function(data) {
	                	if(data.length == 0){
		                    response( [{label: "" , val: -1 }] );
	                	}else{
	                		response(data);
		                }
	                }
            	});
	        },
	        select: function(event, ui) {
	 				if (ui.item.val == -1) {
	                    return false;
	                }
			        $('#main_college_search_autocomplete').val(ui.item.name);
			        $('#main_college_search_autocomplete_id').val(ui.item.id);
	                return false;
	        }
        }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
			if(item.val == -1){
	            return $( "<li></li>" ).data( "ui-autocomplete-item", item ).append( "<a>" + "No result" + "</a>" ).appendTo( ul );
			}else{
	            return $( "<li></li>" ).data( "ui-autocomplete-item", item ).append( "<a>" + item.name + "</a>" ).appendTo( ul );
			}
        };


}



function autocomplete_search_fields() {
	var selected_college_name = "";
	var selected_branch_name = "";
	var selected_course_name = "";
    $('#college_autocomplete').autocomplete({
            minLength: 1,
			delay: 300 ,
            source: function(request, response) {
	            $.ajax({
	                url: "/colleges/autocomplete_elements.json",
	                dataType: "json",
	                data: {
	                    term : request.term
	                },
	                success: function(data) {
	                	if(data.length == 0){
		                    response( [{label: "" , val: -1 }] );
	                	}else{
	                		response(data);
		                }
	                }
            	});
	        },
            focus: function(event, ui) {
                $('#college_autocomplete').val(ui.item.name);
                return false;
            },
	        select: function(event, ui) {
	 				if (ui.item.val == -1) {
	                    return false;
	                }
			        $('#college_autocomplete').val(ui.item.name);
			        $('#college_autocomplete_id').val(ui.item.id);
	                return false;
	        }
        }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
			if(item.val == -1){
	            return $( "<li></li>" ).data( "ui-autocomplete-item", item ).append( "<a>" + "No result" + "</a>" ).appendTo( ul );
			}else{
	            return $( "<li></li>" ).data( "ui-autocomplete-item", item ).append( "<a>" + item.name + "</a>" ).appendTo( ul );
			}
        };
    $('#branch_autocomplete').autocomplete({
            minLength: 1,
			delay: 300 ,
            source: function(request, response) {
	            $.ajax({
	                url: "/branches/autocomplete_elements.json",
	                dataType: "json",
	                data: {
	                    term : request.term
	                },
	                success: function(data) {
	                	if(data.length == 0){
		                    response( [{label: "" , val: -1 }] );
	                	}else{
	                		response(data);
		                }
	                }
            	});
	        },
            focus: function(event, ui) {
                $('#branches_autocomplete').val(ui.item.name);
                return false;
            },
	        select: function(event, ui) {
	 				if (ui.item.val == -1) {
	                    return false;
	                }
			        $('#branch_autocomplete').val(ui.item.name);
			        $('#branch_autocomplete_id').val(ui.item.id);
	                return false;
	        }
        }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
			if(item.val == -1){
	            return $( "<li></li>" ).data( "ui-autocomplete-item", item ).append( "<a>" + "No result" + "</a>" ).appendTo( ul );
			}else{
	            return $( "<li></li>" ).data( "ui-autocomplete-item", item ).append( "<a>" + item.name + "</a>" ).appendTo( ul );
			}
        };
    $('#course_autocomplete').autocomplete({
            minLength: 1,
			delay: 300 ,
            source: function(request, response) {
	            $.ajax({
	                url: "/courses/autocomplete_elements.json",
	                dataType: "json",
	                data: {
	                    term : request.term
	                },
	                success: function(data) {
	                	if(data.length == 0){
		                    response( [{label: "" , val: -1 }] );
	                	}else{
	                		response(data);
		                }
	                }
            	});
	        },
            focus: function(event, ui) {
                $('#course_autocomplete').val(ui.item.name);
                return false;
            },
	        select: function(event, ui) {
	 				if (ui.item.val == -1) {
	                    return false;
	                }
			        $('#course_autocomplete').val(ui.item.name);
			        $('#course_autocomplete_id').val(ui.item.id);
	                return false;
	        }
        }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
			if(item.val == -1){
	            return $( "<li></li>" ).data( "ui-autocomplete-item", item ).append( "<a>" + "No result" + "</a>" ).appendTo( ul );
			}else{
	            return $( "<li></li>" ).data( "ui-autocomplete-item", item ).append( "<a>" + item.name + "</a>" ).appendTo( ul );
			}
        };
		$( "#college_autocomplete, #branch_autocomplete, #course_autocomplete" ).keypress(function() {
			selected_college_name = $("#college_autocomplete").val();
			selected_branch_name  = $("#branch_autocomplete").val();
			selected_course_name  = $("#course_autocomplete").val();
		});
}


$(document).on('page:load', function() {
	autocomplete_search_fields();
	main_college_search_autocomplete();
});

$(document).on('ready', function() {
	autocomplete_search_fields();
	main_college_search_autocomplete();
});

