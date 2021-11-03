document.addEventListener("DOMContentLoaded", pageLoaded);

function pageLoaded() {
    const userId = Cookies.get("id");
    if (!userId) {
        console.log("Can`t get id from Cookies");
        return;
    }

    sendServerRequest(userId);


    function sendServerRequest(userId) {
        const requestUrl = "/api/competitions/users/" + userId;

        ServerRequest.send("GET", requestUrl)
            .then(data => parseServerResponse(data))
            .catch(err => console.log(err));
    }

    function parseServerResponse(data) {
        if (data.length === 0) {
            return;
        }
        // test data
        /*data = [
            {
                ageLimit: null,
                city: null,
                competitors: null,
                endDate: "0001-01-01T00:00:00",
                id: 1,
                isOpen: false,
                isPublic: false,
                sport: null,
                startDate: "0001-01-01T00:00:00",
                state: null,
                streamUrl: null,
                title: "title",
                user: null
            },
            {
                ageLimit: null,
                city: null,
                competitors: null,
                endDate: "0001-01-01T00:00:00",
                id: 2,
                isOpen: false,
                isPublic: false,
                sport: null,
                startDate: "0001-01-01T00:00:00",
                state: null,
                streamUrl: null,
                title: "title2",
                user: null
            }
        ]*/

        const competitionsWrapperEl =
            document.querySelector(".competition-list .row");
        competitionsWrapperEl.innerHTML = "";

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

        const competitionsWrapperEl =
            document.querySelector(".competition-list .row");

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
                  <button class="btn btn-danger" onclick="deleteCompetition(${competitionId})">
                    <ion-icon name="trash-bin-outline" style="font-size: 18px;"></ion-icon>
                  </button>
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

    const requestUrl = "/api/competitions/delete/" + competitionId;

    ServerRequest.send("GET", requestUrl)
        .then(data => removeCompetitionEl(competitionId))
        .catch(err => console.log(err));
}

function removeCompetitionEl(competitionId) {
    const competitionsWrapperEl =
      document.querySelector(".competition-list .row");
    const competitionEl =
      document.querySelector("#competition-" + competitionId);

    competitionsWrapperEl.removeChild(competitionEl);
}



/* Страный блок соревнования

            <div class="col-lg-4 col-md-6 mt-4 pt-2" id="competition-${competitionId}">
                <div class="card blog rounded border-0 shadow overflow-hidden">
                    <div class="position-relative">
                        <img src="assets/img/competition-placeholder.png" class="card-img-top" alt="...">
                        <div class="overlay rounded-top bg-dark"></div>
                    </div>
                    <div class="card-body content">
                        <h5>
                            <p class="card-title title text-dark">
                                ${competitionTitle}
                            </p>
                        </h5>
                        <div class="post-meta d-flex justify-content-between align-items-center mt-3">
                            <a href="/game?id=${competitionId}" class="text-muted readmore">
                                Детальніше
                            </a>
                            <button class="competition-list__delete-button"
                                onclick="deleteCompetition(${competitionId})">
                                <ion-icon name="trash-bin-outline" class="competition-list-list__delete-icon"></ion-icon>
                            </button>
                        </div>
                    </div>
                    <div class="author">
                        <small class="text-light user d-block">Міжнародна федерація спорту</small>
                        <small class="text-light date">${competitionDate}</small>
                    </div>
                </div>
            </div><!--end col-->`

*/