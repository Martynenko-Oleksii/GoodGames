const competitionCategoriesEl =
  document.querySelector(".competition-categories");
const competitionsWrapperEl =
  document.querySelector(".competition-list .row");

const searchInputEl = document.querySelector(".search-input");

document.addEventListener("DOMContentLoaded", updateCompetitionList);
competitionCategoriesEl.addEventListener("change", updateCompetitionList);

function updateCompetitionList() {
  // "all", "favourite sport kinds", "my"
  const competitionCategory = competitionCategoriesEl.value;

  const userId = Cookies.get("id");
  if (!userId) {
    console.log("Can`t get id from Cookies");
    return;
  }

  sendServerRequest();

  function sendServerRequest() {
    const requestParams = new RequestParams();
    switch (competitionCategory) {
      case "all":
        requestParams.url = "/api/competitions";
        break;
      case "favourite sport kinds":
        requestParams.url = "/api/competitions/favourites/" + userId;
        break;
      case "my":
        requestParams.url = "/api/competitions/users/" + userId;
        break;
      default:
        console.log("Wrong competition category: ", competitionCategory);
        return;
    }

    ServerRequest.send(requestParams)
      .then(data => parseServerResponse(data))
      .catch(err => console.log(err));
  }

  function parseServerResponse(data) {
    competitionsWrapperEl.innerHTML = "";

    if (!data.length) {
      competitionsWrapperEl.innerHTML =
        `<div class="no-competitions">
          <img src="assets/img/empty.png" alt="" class="no-competitions__image" style="height: 200px; width: 200px;">
          <p class="no-competitions__message">
            Наразі у вас немає жодного змагання
          </p>
        </div>`;
    }

    for (let competitionInfo of data) {
      createCompetitionElement(competitionInfo);
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

    let deleteCompetitionButtonEl = "";
    if (competitionCategory === "my") {
      deleteCompetitionButtonEl =
        `<button class="btn btn-danger" onclick="deleteCompetition(${competitionId})">
          <ion-icon name="trash-bin-outline" style="font-size: 18px;"></ion-icon>
        </button>`;
    }

    competitionsWrapperEl.innerHTML +=
      `<div class="col-lg-4 col-md-6 mt-4 pt-2" style="cursor: pointer;" id="competition-${competitionId}">
        <div class="card blog rounded border-0 shadow overflow-hidden">
          <div class="card-hover card-body content">
            <h5>
              <p class="card-title title text-dark">
                ${competitionTitle}
              </p>
              <small class="text-dark date" style="font-size: 14px;">Дата: ${competitionDate}</small>
            </h5>
            <div class="post-meta d-flex justify-content-between align-items-center mt-3">
              <a href="/game?id=${competitionId}" class="btn btn-primary">
                Детальніше
              </a>
              ${deleteCompetitionButtonEl}
            </div>
          </div>
        </div>
      </div>`;
  }
}


function deleteCompetition(competitionId) {
  if (!competitionId) {
    console.log("No competition id");
    return;
  }

  const requestParams = new RequestParams();
  requestParams.url = "/api/competitions/delete/" + competitionId;

  ServerRequest.send(requestParams)
    .then(data => removeCompetitionEl(competitionId))
    .catch(err => console.log(err));
}

function removeCompetitionEl(competitionId) {
  const competitionEl =
    document.querySelector("#competition-" + competitionId);

  competitionsWrapperEl.removeChild(competitionEl);
}


searchInputEl.addEventListener("input", () => searchInputElOninput());

function searchInputElOninput() {
  const value = searchInputEl.value;
}