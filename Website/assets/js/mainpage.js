document.addEventListener("DOMContentLoaded", updateCompetitionList);

function updateCompetitionList() {
    sendServerRequest();
  
    function sendServerRequest() {
      const requestParams = new RequestParams();
      requestParams.url = "/api/competitions/";
  
      ServerRequest.send(requestParams)
        .then(data => parseServerResponse(data))
        .catch(err => console.log(err));
    }
  
    function parseServerResponse(data) {
      console.log(data);

      let competitionsWrapperEl = document.querySelector(".compListAll");
      let livestreamEl = document.querySelector(".livestream");
  
      if (!data.length) {
        competitionsWrapperEl.innerHTML = '<p class="card"> Наразі немає жодного змагання</p>';
        return;
      }
      
      let maxcomplist = 0;
      for (let competitionInfo of data) {
          if(maxcomplist < 21){
            const competitionId = competitionInfo.id;
            const competitionTitle = competitionInfo.title;
            const competitionDate =
              new Date(competitionInfo.startDate).toLocaleDateString();
            
              competitionsWrapperEl.innerHTML +=
              `<div style="margin-bottom: 10px;" class="border-card rounded-lg w-full px-8 py-6 bg-white shadow cursor-pointer border-transparent border-2 hover:border-indigo-500 clearfix" onclick="window.location = 'game/?id=${competitionId}';">
                  <h2 class="text-indigo-500 font-bold">${competitionTitle}</h2>
                  <p class="mt-2 text-gray-600 text-sm">Дата: ${competitionDate}</p>
              </div>`;

            if(competitionInfo.streamUrl != null || competitionInfo.streamUrl != ""){
                let linkstream = competitionInfo.streamUrl;
                let id_live = "";
                if(linkstream.indexOf("https://www.youtube.com/watch?v=") + 1){
                    var vars = {};
                    linkstream.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
                        vars[key] = value;
                    });
                    id_live =  vars.v;
                }
            
                if(linkstream.indexOf("https://youtu.be/") + 1){
                    var str = "Hello <!Doctype";
                    id_live = linkstream.replace("https://youtu.be/", "");
                }
                
                if(linkstream.indexOf("https://www.youtube.com/embed/") + 1){
                    var str = "Hello <!Doctype";
                    id_live = linkstream.replace("https://www.youtube.com/embed/", "");
                }

                livestreamEl.innerHTML +=
                `<div class="video-block" onclick="location.href = '/game/stream/?id=${competitionId}';" style="background-size: cover; background-image: url(https://i.ytimg.com/vi/${id_live}/maxresdefault.jpg);">
                    <div class="live_icon">
                        <p>Live</p>
                    </div>
                </div>`;
            }

          }else{
              return;
          }
          maxcomplist++;
      }
    }
}


// УДАЛИТЬ
function login_test(){
    Cookies.set("id", 1);
    Cookies.set("login", "User System");
    Cookies.set("email", "user@gg.ua")
}