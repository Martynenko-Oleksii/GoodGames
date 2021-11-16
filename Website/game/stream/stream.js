document.addEventListener("DOMContentLoaded", pageLoaded);

function pageLoaded() {
  competitionId = parseInt(getUrlVars().id);
  if (!competitionId) {
    history.back();
  }
  document.getElementById("chat_frame").src = "shoutbox/?id=" + competitionId;
  updateStreamInfo();
}

function updateStreamInfo() {
    sendServerRequest();
  
    function sendServerRequest() {
      const requestParams = new RequestParams();
      requestParams.url = "/api/competitions/" + competitionId;
  
      ServerRequest.send(requestParams)
        .then(data => parseServerResponse(data))
        .catch(err => console.log(err));
    }
  
    function parseServerResponse(data) {
      // data приходит в виде массива с одним элементом - объектом с информацией
  
      if (data.length === 0) {
        history.back();
        return;
      }
  
      const info = data[0];
      if (!info) {
        history.back();
        return;
      }
  
      if(info.streamUrl == null){
        history.back();
        return;
      }

      console.log(info);
      let linkstream = info.streamUrl;

      getPlayStrean(linkstream);

      document.getElementById("link_gama").href = "../?id=" + competitionId;
      document.getElementById("name_game").textContent = info.title;
      document.getElementById("sub_game").textContent = info.description;
    }
}

function getPlayStrean(linkstream){
    // Получение идентификатора видео из сслыки.

    let id = "";
    if(linkstream.indexOf("https://www.youtube.com/watch?v=") + 1){
        var vars = {};
        linkstream.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
            vars[key] = value;
        });
        id =  vars.v;
        setTimeout(play(id), 1000);
    }

    if(linkstream.indexOf("https://youtu.be/") + 1){
        var str = "Hello <!Doctype";
        id = linkstream.replace("https://youtu.be/", "");
        setTimeout(play(id), 1000);
    }
    
    if(linkstream.indexOf("https://www.youtube.com/embed/") + 1){
        var str = "Hello <!Doctype";
        id = linkstream.replace("https://www.youtube.com/embed/", "");
        setTimeout(play(id), 1000);
    }
}

function play(id){
        //Запуск трансляции
        document.getElementById("live_frame").src = "https://www.youtube.com/embed/" + id + "?autoplay=1";
        document.getElementById("chat_frame").src = "https://beesportal.online/shoutbox/?id=" + competitionId + "&login=" + Cookies.get('login');
}