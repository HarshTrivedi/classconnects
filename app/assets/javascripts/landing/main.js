
    $(document).ready(function(){

    	$('.counter').each(function() {
    	  var $this = $(this),
    	      countTo = $this.attr('data-count');
    	  
    	  $({ countNum: $this.text()}).animate({
    	    countNum: countTo
    	  },

    	  {

    	    duration: 5000,
    	    easing:'linear',
    	    step: function() {
    	      $this.text(Math.floor(this.countNum));
    	    },
    	    complete: function() {
    	      $this.text(this.countNum);
    	      //alert('finished');
    	    }

    	  });  
    	  
    	  

    	});
    });



    $(document).ready(function(){
        $("#link-feature-1").click(function(event){
            $("#feature-1").addClass('active');
            $("#feature-2").removeClass('active');
            $("#feature-3").removeClass('active');
            $("#feature-4").removeClass('active');
            $("#feature-5").removeClass('active');
            document.getElementById("tab-feature-1").style.display="block";
            document.getElementById("tab-feature-1").style.position="static";
            document.getElementById("tab-feature-1").style.visibility="visible";
            
            document.getElementById("tab-feature-2").style.display="none";
            document.getElementById("tab-feature-3").style.display="none";
            document.getElementById("tab-feature-4").style.display="none";
            document.getElementById("tab-feature-5").style.display="none";
        });
        $("#link-feature-2").click(function(event){
            $("#feature-2").addClass('active');
            $("#feature-1").removeClass('active');
            $("#feature-3").removeClass('active');
            $("#feature-4").removeClass('active');
            $("#feature-5").removeClass('active');
            
            document.getElementById("tab-feature-2").style.display="block";
            document.getElementById("tab-feature-2").style.position="static";
            document.getElementById("tab-feature-2").style.visibility="visible";
            document.getElementById("tab-feature-1").style.display="none";
            document.getElementById("tab-feature-3").style.display="none";
            document.getElementById("tab-feature-4").style.display="none";
            document.getElementById("tab-feature-5").style.display="none";
           
      });
        $("#link-feature-3").click(function(event){
            $("#feature-3").addClass('active');
            $("#feature-1").removeClass('active');
            $("#feature-2").removeClass('active');
            $("#feature-4").removeClass('active');
            $("#feature-5").removeClass('active');
            
            document.getElementById("tab-feature-3").style.display="block";
            document.getElementById("tab-feature-3").style.position="static";
            document.getElementById("tab-feature-3").style.visibility="visible";
            document.getElementById("tab-feature-1").style.display="none";
            document.getElementById("tab-feature-2").style.display="none";
            document.getElementById("tab-feature-4").style.display="none";
            document.getElementById("tab-feature-5").style.display="none";
        });
        $("#link-feature-4").click(function(event){
            $("#feature-4").addClass('active');
            $("#feature-1").removeClass('active');
            $("#feature-2").removeClass('active');
            $("#feature-3").removeClass('active');
            $("#feature-5").removeClass('active');
            
            document.getElementById("tab-feature-4").style.display="block";
            document.getElementById("tab-feature-4").style.position="static";
            document.getElementById("tab-feature-4").style.visibility="visible";
            document.getElementById("tab-feature-1").style.display="none";
            document.getElementById("tab-feature-2").style.display="none";
            document.getElementById("tab-feature-3").style.display="none";
            document.getElementById("tab-feature-5").style.display="none";
        });
        $("#link-feature-5").click(function(event){
            $("#feature-5").addClass('active');
            $("#feature-1").removeClass('active');
            $("#feature-2").removeClass('active');
            $("#feature-4").removeClass('active');
            $("#feature-3").removeClass('active');
            
            document.getElementById("tab-feature-5").style.display="block";
            document.getElementById("tab-feature-5").style.position="relative";
            document.getElementById("tab-feature-5").style.visibility="visible";
            document.getElementById("tab-feature-1").style.display="none";
            document.getElementById("tab-feature-2").style.display="none";
            document.getElementById("tab-feature-4").style.display="none";
            document.getElementById("tab-feature-3").style.display="none";
        });
                        
    });