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
      var competitionsWrapperEl = document.querySelector(".card-list .compListAll");
      competitionsWrapperEl.innerHTML = "";
  
      if (!data.length) {
        competitionsWrapperEl.innerHTML =
          ` <p class="card">
              Наразі немає жодного змагання
            </p>
          `;
      }
      
      for (let competitionInfo of data) {
        const competitionId = competitionInfo.id;
        const competitionTitle = competitionInfo.title;
        const competitionDate =
          new Date(competitionInfo.startDate).toLocaleDateString();
        
          competitionsWrapperEl.innerHTML +=
          `<div class="border-card rounded-lg w-full px-8 py-6 bg-white shadow cursor-pointer border-transparent border-2 hover:border-indigo-500 clearfix" onclick="window.location = 'game/?id=${competitionId}';">
              <h2 class="text-indigo-500 font-bold">${competitionTitle}</h2>
              <p class="mt-2 text-gray-600 text-sm">Дата: ${competitionDate}</p>
          </div>`;
    }
  }
}