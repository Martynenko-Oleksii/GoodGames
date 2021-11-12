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
  
      if (!data.length) {
        competitionsWrapperEl.innerHTML = '<p class="card"> Наразі немає жодного змагання</p>';
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
          }else{
              return;
          }
          maxcomplist++;
      }
    }
}