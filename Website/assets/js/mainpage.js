document.addEventListener("DOMContentLoaded", updateCompetitionList);
const competitionsWrapperEl =
  document.querySelector(".card-list .compListAll");

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
      competitionsWrapperEl.innerHTML = "";
  
      if (!data.length) {
        competitionsWrapperEl.innerHTML =
          ` <p class="card">
              Наразі немає жодного змагання
            </p>
          `;
      }
      
      let maxcomplist = 0;
      for (let competitionInfo of data) {
          if(maxcomplist < 21){
            createCompetitionElement(competitionInfo);
          }else{
              return;
          }
          maxcomplist++;
        }
    }
  
    function createCompetitionElement(competitionInfo) {
      if (!competitionInfo) {
        console.log("No competition info");
        return;
      }
  
      const competitionId = competitionInfo.id;
      const competitionTitle = competitionInfo.title;
      const competitionDate =
        new Date(competitionInfo.startDate).toLocaleDateString();
  
      if (!competitionId || !competitionTitle || !competitionDate) {
        console.log("Something wrong with competition info");
        return;
      }
  
      competitionsWrapperEl.innerHTML +=
        `<div class="border-card rounded-lg w-full px-8 py-6 bg-white shadow cursor-pointer border-transparent border-2 hover:border-indigo-500 clearfix" onclick="window.location = 'game/?id=${competitionId}';">
            <h2 class="text-indigo-500 font-bold">${competitionTitle}</h2>
            <p class="mt-2 text-gray-600 text-sm">Дата: ${competitionDate}</p>
        </div>`;
    }
  }