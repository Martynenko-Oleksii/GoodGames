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
      getMYNewsFromServer();
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
  }

  function parseOneNews(oneNewsInfo) {
    const id = oneNewsInfo.id;
    const header = oneNewsInfo.header;
    let body = oneNewsInfo.body || "До події не доданий опис";

    body = limitStr(body, 100);

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
              <img src="${imageUrl}" width="125" height="160" alt="" style="border-radius: 15px; top: 25px; position: relative;">
          </div>
          <div style="display: block; width: 80%; margin-left: 10px; margin-right: 10px;">
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



const MYnewsWrapperEl = document.querySelector(".list_my_news");
function getMYNewsFromServer() {
  sendServerRequest();

  function sendServerRequest() {
    const requestParams = new RequestParams();
    requestParams.url = "/api/news/user/" + Cookies.get("id");
    ServerRequest.send(requestParams)
      .then(data => parseServerResponse(data))
      .catch(err => console.log(err));
  }

  function parseServerResponse(serverResponse) {
    MYnewsWrapperEl.innerHTML = "";

    if (!serverResponse || !serverResponse.length) {
      MYnewsWrapperEl.innerHTML =
        `<article class="card">
            <a>Новин немає.</a>
          </article>`;
      return;
    }

    serverResponse = serverResponse.reverse();
    for (let oneNewsInfo of serverResponse) {
      parseMyNews(oneNewsInfo);
    }
  }

  function parseMyNews(oneNewsInfo) {
    const id = oneNewsInfo.id;
    const header = oneNewsInfo.header;
    let body = oneNewsInfo.body || "До події не доданий опис";
    const competitionId = oneNewsInfo.competitionId;

    body = limitStr(body, 100);

    const months = ["січня", "лютого", "березня", "квітня", "травня", "червня", "липня", "серпня", "вересня", "жовтня", "листопада", "грудня"]
    const date = new Date(oneNewsInfo.date);
    const day = date.getDate();
    const month = months[date.getMonth()];

    MYnewsWrapperEl.innerHTML +=
      `<div style="margin-top: 15px;" class="rounded-lg w-full px-8 py-6 bg-white shadow cursor-pointer border-transparent border-2 hover:border-indigo-500 clearfix" onclick="window.location = '#';">
          <svg class="fill-current text-indigo-500 w-6 h-6 float-left mr-2" viewBox="0 0 20 20"><path d="M12.871,9.337H7.377c-0.304,0-0.549,0.246-0.549,0.549c0,0.303,0.246,0.55,0.549,0.55h5.494 c0.305,0,0.551-0.247,0.551-0.55C13.422,9.583,13.176,9.337,12.871,9.337z M15.07,6.04H5.179c-0.304,0-0.549,0.246-0.549,0.55 c0,0.303,0.246,0.549,0.549,0.549h9.891c0.303,0,0.549-0.247,0.549-0.549C15.619,6.286,15.373,6.04,15.07,6.04z M17.268,1.645 H2.981c-0.911,0-1.648,0.738-1.648,1.648v10.988c0,0.912,0.738,1.648,1.648,1.648h4.938l2.205,2.205l2.206-2.205h4.938 c0.91,0,1.648-0.736,1.648-1.648V3.293C18.916,2.382,18.178,1.645,17.268,1.645z M17.816,13.732c0,0.607-0.492,1.1-1.098,1.1 h-4.939l-1.655,1.654l-1.656-1.654H3.531c-0.607,0-1.099-0.492-1.099-1.1v-9.89c0-0.607,0.492-1.099,1.099-1.099h13.188 c0.605,0,1.098,0.492,1.098,1.099V13.732z"></path></svg>
          <h2 class="text-indigo-500 font-bold">${header}</h2>
          <p class="mt-2 text-gray-600 text-sm">${body}</p>
          <a href="/game/?id=${competitionId}" class="underline float-right text-xs text-blue-600">Сторінка змагання</a>
      </div>`;
  }
}

function limitStr(str, n, symb) {
  if (!n && !symb) return str;
  symb = symb || '...';
  return str.substr(0, n - symb.length) + symb;
}