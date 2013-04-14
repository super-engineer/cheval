$(function(){
  $(".left_sidebar").css('height', $(".center_content").height()-38);  
  
  $(window).resize(function(){
    $(".left_sidebar").css('height', $(".center_content").height()-38);  
  });
});

