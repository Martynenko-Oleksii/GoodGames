document.addEventListener("DOMContentLoaded", pageLoaded);

function pageLoaded() {
    const userId = Cookies.get("id");
    if (!userId) {
        console.log("Can`t get id from Cookies");
        return;
    }

    sendServerRequest();


    function sendServerRequest(userId) {
        const requestUrl = "api/competitions/users/" + userId;

        ServerRequest.send("GET", requestUrl)
            .then(data => parseServerResponse(data))
            .catch(err => console.log(err));
    }

    function parseServerResponse(data) {
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
            `<div class="col-lg-4 col-md-6 mt-4 pt-2">
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
                            <a href="/game" class="text-muted readmore" onclick="goToCompetition(${competitionId})">
                                Детальніше
                            </a>
                            <button class="competition-list__delete-button" onclick="deleteCompetition(${competitionId})">
                                <ion-icon name="trash-bin-outline" class="competition-list-list__delete-icon"></ion-icon>
                            </button>
                        </div>
                    </div>
                    <div class="author">
                        <small class="text-light user d-block">Міжнародна федерація спорту</small>
                        <small class="text-light date">${competitionDate}</small>
                    </div>
                </div>
            </div><!--end col-->`;
    }
}


function deleteCompetition(competitionId) {
    if (!competitionId) {
        console.log("No competition id");
        return;
    }

    const requestUrl = "api/competitions/delete/" + competitionId;

    ServerRequest.send("GET", requestUrl)
        .then(data => console.log(data))
        .catch(err => console.log(err));
}

function goToCompetition(competitionId) {
    localStorage.setItem("openedCompetitionId", competitionId);
}