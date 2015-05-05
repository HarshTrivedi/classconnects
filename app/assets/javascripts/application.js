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
//= bootstrap-tooltip.js
//= require toastr
//= require chosen-jquery
//= require s3_direct_upload
//= require nprogress.js
//= require jquery.cookie.js
//= require jquery_validator.js




function enable_side_bar_toggle(){
	/** BUTTON TOGGLE FUNCTION **/
	$(".btn-collapse-sidebar-left").click(function(){
		"use strict";
		if($(".top-navbar").hasClass("toggle")){
			$.cookie("toggle" , "" );
		}else{
			$.cookie("toggle" , "toggle");
		}


		$(".top-navbar").toggleClass("toggle");
		$(".sidebar-left").toggleClass("toggle");
		$(".page-content").toggleClass("toggle");
		$(".icon-dinamic").toggleClass("rotate-180");
		
		if ($(window).width() > 991) {
			if($(".sidebar-right").hasClass("toggle-left") === true){
				$(".sidebar-right").removeClass("toggle-left");
				$(".top-navbar").removeClass("toggle-left");
				$(".page-content").removeClass("toggle-left");
				$(".sidebar-left").removeClass("toggle-left");
				if($(".sidebar-left").hasClass("toggle") === true){
					$(".sidebar-left").removeClass("toggle");
				}
				if($(".page-content").hasClass("toggle") === true){
					$(".page-content").removeClass("toggle");
				}
			}
		}
	});
	$(".btn-collapse-sidebar-right").click(function(){
		"use strict";
		$(".top-navbar").toggleClass("toggle-left");
		$(".sidebar-left").toggleClass("toggle-left");
		$(".sidebar-right").toggleClass("toggle-left");
		$(".page-content").toggleClass("toggle-left");
	});
	$(".btn-collapse-nav").click(function(){
		"use strict";
		$(".icon-plus").toggleClass("rotate-45");
	});
	/** END BUTTON TOGGLE FUNCTION **/

}



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










function cascade_enroll_college_branch() {
	var selected_enroll_college_name = "";
	var selected_enroll_branch_name = "";
    $('#enroll_college_autocomplete').autocomplete({
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
                $('#enroll_college_autocomplete').val(ui.item.name);
                return false;
            },
	        select: function(event, ui) {
	 				if (ui.item.val == -1) {
	                    return false;
	                }
			        $('#enroll_college_autocomplete').val(ui.item.name);
			        $('#enroll_college_autocomplete_id').val(ui.item.id);
	                return false;
	        }
        }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
			if(item.val == -1){
	            return $( "<li></li>" ).data( "ui-autocomplete-item", item ).append( "<a>" + "No result" + "</a>" ).appendTo( ul );
			}else{
	            return $( "<li></li>" ).data( "ui-autocomplete-item", item ).append( "<a>" + item.name + "</a>" ).appendTo( ul );
			}
        };
    $('#enroll_branch_autocomplete').autocomplete({
            minLength: 1,
			delay: 300 ,
            source: function(request, response) {
	            $.ajax({
	                url: "/branches/autocomplete_elements.json",
	                dataType: "json",
	                data: {
	                    term : request.term,
	                    college_name : selected_enroll_college_name
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
			        $('#enroll_branch_autocomplete').val(ui.item.name);
			        $('#enroll_branch_autocomplete_id').val(ui.item.id);
	                return false;
	        }
        }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
			if(item.val == -1){
	            return $( "<li></li>" ).data( "ui-autocomplete-item", item ).append( "<a>" + "No result" + "</a>" ).appendTo( ul );
			}else{
	            return $( "<li></li>" ).data( "ui-autocomplete-item", item ).append( "<a>" + item.name + "</a>" ).appendTo( ul );
			}
        };

		$( "#enroll_college_autocomplete, #enroll_branch_autocomplete" ).keypress(function() {
			selected_enroll_college_name = $("#enroll_college_autocomplete").val();
			selected_enroll_branch_name  = $("#enroll_branch_autocomplete").val();
		});
}


$(document).on('page:load', function() {
	autocomplete_search_fields();
	main_college_search_autocomplete();
	cascade_enroll_college_branch();
    $('.carousel').carousel({ interval: 15000 })
	tour_guide();
	$('[data-toggle="tooltip"]').tooltip();
	enable_side_bar_toggle();
});

$(document).on('ready', function() {
	autocomplete_search_fields();
	main_college_search_autocomplete();
	cascade_enroll_college_branch();
    $('.carousel').carousel({ interval: 15000 })
	tour_guide();
	$('[data-toggle="tooltip"]').tooltip();
	enable_side_bar_toggle();
});

$(document).on('page:fetch',   function() { NProgress.start(); });
$(document).on('page:change',  function() { NProgress.done(); });
$(document).on('page:restore', function() { NProgress.remove(); });



//circle sidebar
function setProgress(num){
  var $spinner = $('.progress-circle .spinner');
  var $filler = $('.progress-circle .filler');
  var $percentage = $('.progress-circle .percentage');
  
  if (num < 0) num = 0;
  if (num > 100) num = 100;
  
  var initialNum = $percentage.text().replace('%','');
  $({numVal:initialNum}).animate({numVal:num},{
    duration: 1000,
    easing: 'swing',
    step: function (currVal) {
      $percentage.text(Math.ceil(currVal) + '%');
      if (currVal > 0 && currVal <= 50) {
        $filler.css('display', 'none');
        var spinnerDegs = -180 + ((currVal * 180) / 50);
        rotate($spinner, spinnerDegs);
      } else if (currVal > 50) {
        rotate($spinner, 0);
        $filler.css('display', '');
        var fillerDegs = 0 + ((currVal * 180) / 50);
        rotate($filler, fillerDegs);
      }
    }
  });

}

function rotate($el, deg) {
  $el.css({
    '-webkit-transform': 'rotate(' + deg + 'deg)',
    '-moz-transform': 'rotate(' + deg + 'deg)',
    '-ms-transform': 'rotate(' + deg + 'deg)',
    '-o-transform': 'rotate(' + deg + 'deg)',
    'transform': 'rotate(' + deg + 'deg)'
  });
}



function tour_guide(){
	console.log( Number($("#sign_in_count").html().trim()) );
	if(  Number($("#sign_in_count").html().trim())  <= 1 ){
		if( window.location.pathname == "/"){
			start_tour_guide();
		}
	}
}

function start_tour_guide() {
	$('#step-1').hide();
	$('#step-3').hide();
	$('#step-4').hide();
	$('#step-5').hide();
	$('#step-6').hide();
	$('#step-7').hide();
	$('#step-8').hide();
	$('#step-9').hide();
	$('#step-10').hide();
	$('#step-11').hide();
	$('#step-12').hide();

/*	$('#next-1').click(function(event){
		event.preventDefault();
		$('#step-2').show();
		$('#step-1').hide();
	});
	$('#end_tour-1').click(function(event){
		event.preventDefault();
		$('#step-1').hide();
		$.post( "/seen_tour_guide");
	});

	$('#prev-2').click(function(event){
		event.preventDefault();
		$('#step-1').show();
		$('#step-2').hide();
	});*/
	$('#next-2').click(function(event){
		event.preventDefault();
		$('#step-3').show();
		$('#step-2').hide();
	});
	$('#end_tour-2').click(function(event){
		event.preventDefault();
		$('#step-2').hide();
		$.post( "/seen_tour_guide");
	});


	$('#prev-3').click(function(event){
		event.preventDefault();
		$('#step-2').show();
		$('#step-3').hide();
	});
	$('#next-3').click(function(event){
		event.preventDefault();
		$('#step-4').show();
		$('#step-3').hide();
	});
	$('#end_tour-3').click(function(event){
		event.preventDefault();
		$('#step-3').hide();
		$.post( "/seen_tour_guide");
	});


	$('#prev-4').click(function(event){
		event.preventDefault();
		$('#step-3').show();
		$('#step-4').hide();
	});
	$('#next-4').click(function(event){
		event.preventDefault();
		$('#step-5').show();
		$('#step-4').hide();
	});
	$('#end_tour-4').click(function(event){
		event.preventDefault();
		$('#step-4').hide();
		$.post( "/seen_tour_guide");
	});

	$('#prev-5').click(function(event){
		event.preventDefault();
		$('#step-4').show();
		$('#step-5').hide();
	});
	$('#next-5').click(function(event){
		event.preventDefault();
		$('#step-6').show();
		$('#step-5').hide();
	});
	$('#end_tour-5').click(function(event){
		event.preventDefault();
		$('#step-5').hide();
		$.post( "/seen_tour_guide");
	});

	$('#prev-6').click(function(event){
		event.preventDefault();
		$('#step-5').show();
		$('#step-6').hide();
	});
	$('#next-6').click(function(event){
		event.preventDefault();
		$('#step-7').show();
		$('#step-6').hide();
	});
	$('#end_tour-6').click(function(event){
		event.preventDefault();
		$('#step-6').hide();
		$.post( "/seen_tour_guide");
	});

	$('#prev-7').click(function(event){
		event.preventDefault();
		$('#step-6').show();
		$('#step-7').hide();
	});
	$('#next-7').click(function(event){
		event.preventDefault();
		$('#step-8').show();
		$('#step-7').hide();
	});
	$('#end_tour-7').click(function(event){
		event.preventDefault();
		$('#step-7').hide();
		$.post( "/seen_tour_guide");
	});

	$('#prev-8').click(function(event){
		event.preventDefault();
		$('#step-7').show();
		$('#step-8').hide();
	});
	$('#next-8').click(function(event){
		event.preventDefault();
		$('#step-9').show();
		$('#step-8').hide();
	});
	$('#end_tour-8').click(function(event){
		event.preventDefault();
		$('#step-8').hide();
		$.post( "/seen_tour_guide");
	});

	$('#prev-9').click(function(event){
		event.preventDefault();
		$('#step-8').show();
		$('#step-9').hide();
	});
	$('#next-9').click(function(event){
		event.preventDefault();
		$('#step-10').show();
		$('#step-9').hide();
	});
	$('#end_tour-9').click(function(event){
		event.preventDefault();
		$('#step-9').hide();
		$.post( "/seen_tour_guide");
	});

	$('#prev-10').click(function(event){
		event.preventDefault();
		$('#step-9').show();
		$('#step-10').hide();
	});
	$('#next-10').click(function(event){
		event.preventDefault();
		$('#step-11').show();
		$('#step-10').hide();
	});
	$('#end_tour-10').click(function(event){
		event.preventDefault();
		$('#step-10').hide();
		$.post( "/seen_tour_guide");
	});

	$('#prev-11').click(function(event){
		event.preventDefault();
		$('#step-10').show();
		$('#step-11').hide();
	});
	$('#next-11').click(function(event){
		event.preventDefault();
		$('#step-12').show();
		$('#step-11').hide();
	});
	$('#end_tour-11').click(function(event){
		event.preventDefault();
		$('#step-11').hide();
		$.post( "/seen_tour_guide");
	});

	$('#prev-12').click(function(event){
		event.preventDefault();
		$('#step-11').show();
		$('#step-12').hide();
	});
	$('#end_tour-12').click(function(event){
		event.preventDefault();
		$('#step-12').hide();
		$.post( "/seen_tour_guide");
	});



}

$('form').submit(function(){
    $(':submit', this).click(function() {
        return false;
    });
});




