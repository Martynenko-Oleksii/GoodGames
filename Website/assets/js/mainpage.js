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

            if(competitionInfo.streamUrl != null){
                if(competitionInfo.streamUrl.length > 0){
                  let id_live = get_id_live(competitionInfo.streamUrl);

                  livestreamEl.innerHTML +=
                  `<div class="video-block" onclick="location.href = '/game/stream/?id=${competitionId}';" style="background-size: cover; background-image: url(https://i.ytimg.com/vi/${id_live}/maxresdefault.jpg);">
                      <div class="live_icon">
                          <p>Live</p>
                      </div>
                  </div>`;
                }else{
                  return;
                }

            }

          }else{
              return;
          }
          maxcomplist++;
      }
      getNewsFromServer();
    }

    function get_id_live(linkstream){
        // Получение идентификатора видео из сслыки.
        let id = "";
        if(linkstream.indexOf("https://www.youtube.com/watch?v=") + 1){
            var vars = {};
            linkstream.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
                vars[key] = value;
            });
            id =  vars.v;
            return id;
        }

        if(linkstream.indexOf("https://youtu.be/") + 1){
            id = linkstream.replace("https://youtu.be/", "");
            return id;
        }
        
        if(linkstream.indexOf("https://www.youtube.com/embed/") + 1){
            id = linkstream.replace("https://www.youtube.com/embed/", "");
            return id;
        }
    }
}

const newsWrapperEl = document.querySelector(".news_list");
function getNewsFromServer() {
  sendServerRequest();

  function sendServerRequest() {
    const requestParams = new RequestParams();
    requestParams.url = "/api/news";
    ServerRequest.send(requestParams)
      .then(data => parseServerResponse(data))
      .catch(err => console.log(err));
  }

  function parseServerResponse(serverResponse) {
    newsWrapperEl.innerHTML = "";

    if (!serverResponse || !serverResponse.length) {
      newsWrapperEl.innerHTML =
        `<article class="card" style="display: -webkit-box;">
            <div style="display: block; width: 90%; margin-left: 10px; margin-right: 10px;">
                <div class="card-header">
                    <a>Новин немає.</a>
                </div>
            </div>
        </article>`;
      return;
    }

    serverResponse = serverResponse.reverse();
    let maxcomplist = 0;
    for (let oneNewsInfo of serverResponse) {
      if(maxcomplist < 21){
        parseOneNews(oneNewsInfo);
      }else{
        return;
      }
      maxcomplist++;
    }

    document.body.appendChild(scriptEl)
  }

  function parseOneNews(oneNewsInfo) {
    const id = oneNewsInfo.id;
    const header = oneNewsInfo.header;
    const body = oneNewsInfo.body || "До події не доданий опис";

    const months = ["січня", "лютого", "березня", "квітня", "травня", "червня", "липня", "серпня", "вересня", "жовтня", "листопада", "грудня"]
    const date = new Date(oneNewsInfo.date);
    const day = date.getDate();
    const month = months[date.getMonth()];

    const headerFirstWord = oneNewsInfo.header.split(":")[0].toLowerCase();
    let imageUrl = "https://res.cloudinary.com/muhammederdem/image/upload/q_60/v1537132205/news-slider/item-2.webp";
    if (headerFirstWord === "створено") {
      imageUrl = "news/image/new.png";
    } else if (headerFirstWord === "розпочато") {
      imageUrl = "news/image/start.png";
    } else if (headerFirstWord === "завершено") {
      imageUrl = "news/image/end.png";
    }

    newsWrapperEl.innerHTML +=
      `<article class="card" style="display: -webkit-box;">
          <div class="pc">
              <img src="${imageUrl}" width="250" height="160" alt="" style="border-radius: 15px;">
          </div>
          <div style="display: block; width: 90%; margin-left: 10px; margin-right: 10px;">
              <div class="card-header">
                  <a href="#">${header}</a>
              </div>
              <div class="card-meta">
                  <p>${body}</p>
              </div>
              <div class="card-footer">
                  <div class="card-meta card-meta--date">
                      <ion-icon name="calendar-outline" class="nav__icon" style="margin-right: 5px;"></ion-icon>
                      ${day} ${month}
                  </div>
              </div>
          </div>
      </article>`;
  }
}