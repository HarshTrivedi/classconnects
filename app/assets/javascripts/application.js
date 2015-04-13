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
//= require jquery_ujs
//= require jquery-ui
//= require turbolinks
//= require jquery_007.js
//= require jquery_008.js
//= require jquery_010.js
//= require jquery_015.js
//= require retina.js
//= require demo-panel.js
//= require bootstrap_002.js

//= require toastr
//= require chosen-jquery
//= require s3_direct_upload

//= require bootstrapValidator.min.js


$(document).ready(function() {
	$("form").bootstrapValidator();
});