
// Add a button near the "Answer" headers and hide the solution
// which is supposed to be a blockquote.
$(".answer").each(function(){
    var p = $("p:first", this);
    p.append("<span class='fold-unfold glyphicon glyphicon-collapse-down'></span>");
    $("blockquote", this).hide();
});


// On click, toggle visibility.
$(".answer").click(function(){
    $("blockquote", this).toggle(400);
    $(".fold-unfold", this).toggleClass("glyphicon-collapse-down glyphicon-collapse-up");
});

