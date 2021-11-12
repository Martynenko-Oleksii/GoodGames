$(function(){

    // Storing some elements in variables for a cleaner code base

    var variss = {};
    document.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        variss[key] = value;
    });
    let identi_game =  variss.id;

    var refreshButton = $('h1 img'),
        shoutboxForm = $('.shoutbox-form'),
        form = shoutboxForm.find('form'),
        closeForm = shoutboxForm.find('h2 span'),
        nameElement = form.find('#shoutbox-name'),
        commentElement = form.find('#shoutbox-comment'),
        ul = $('ul.shoutbox-content'), identi = identi_game;


    // Replace :) with emoji icons:
    emojione.ascii = true;

    // Load the comments.
    load();
    
    // On form submit, if everything is filled in, publish the shout to the database
    
    var canPostComment = true;

    form.submit(function(e){
        e.preventDefault();

        if(!canPostComment) return;
        
        var name = nameElement.val().trim();
        var comment = commentElement.val().trim();
        var id = identi_game;

        if(name.length && comment.length && comment.length < 240) {
        
            publish(name, comment, id);

            // Prevent new shouts from being published

            canPostComment = false;

            // Allow a new comment to be posted after 2 seconds

            setTimeout(function(){
                canPostComment = true;
            }, 2000);

        }
        if(Cookies.get('login') != undefined){
            document.getElementById("shoutbox-name").value = Cookies.get("login");
            document.getElementById("shoutbox-name").style.display = "none";
        }
    });
    
    // Toggle the visibility of the form.
    
    formOpen();
    
    // Clicking on the REPLY button writes the name of the person you want to reply to into the textbox.
    
    ul.on('click', '.shoutbox-comment-reply', function(e){
        
        var replyName = $(this).data('name');
        
        formOpen();
        commentElement.val('@'+replyName+' ').focus();

    });
    
    // Clicking the refresh button will force the load function
    
    var canReload = true;

    refreshButton.click(function(){

        if(!canReload) return false;
        
        load();
        canReload = false;

        // Allow additional reloads after 2 seconds
        setTimeout(function(){
            canReload = true;
        }, 2000);
    });

    // Automatically refresh the shouts every 20 seconds
    setInterval(load, 1000);


    function formOpen(){
        
        if(form.is(':visible')) return;

        form.slideDown();
        closeForm.fadeIn();
    }

    function formClose(){

        if(!form.is(':visible')) return;

        form.slideUp();
        closeForm.fadeOut();
    }

    // Store the shout in the database
    
    function publish(name,comment,id){
    
        $.post('publish.php', {name: name, comment: comment, id: id}, function(){
            nameElement.val("");
            commentElement.val("");
            load();
        });

    }
    
    // Fetch the latest shouts
    
    function load(){
        $.getJSON('./load.php/?id=' + identi_game, function(data) {
            appendComments(data);
        });
    }
    
    // Render an array of shouts as HTML
    
    function appendComments(data) {

        ul.empty();

        data.forEach(function(d){
            ul.append('<li>'+
                '<span class="shoutbox-username">' + d.name + '</span>'+
                '<p class="shoutbox-comment">' + emojione.toImage(d.text) + '</p>'+
                '<div class="shoutbox-comment-details"><span class="shoutbox-comment-reply" data-name="' + d.name + '">Відповісти</span>'+
                '<span class="shoutbox-comment-ago">' + d.timeAgo + '</span></div>'+
            '</li>');
        });

    }

});