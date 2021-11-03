document.addEventListener("DOMContentLoaded", pageLoaded);

function pageLoaded() {
    const competitionId = parseInt(getUrlVars().id);
    if (!competitionId) {
        return;
    }

    getCompetitionInfoFromServer(competitionId);
    //parseServerResponse([true]);

    function getCompetitionInfoFromServer(competitionId) {
        const requestUrl = "/api/competitions/" + competitionId;

        ServerRequest.send("GET", requestUrl)
            .then(data => parseServerResponse(data))
            .catch(err => console.log(err));
    }

    function parseServerResponse(data) {
        // test data
        /*data = [
            {
                "id": 2,
                "title": "tespetition",
                "isOpen": false,
                "sport": {
                    "id": 1,
                    "title": "Футбол",
                    "minCompetitorsCount": 22,
                    "hasTeam": true,
                    "minTeamsCount": 2,
                    "teamSize": 11,
                    "hasGrid": true
                },
                "ageLimit": "58",
                "city": "Sidney",
                "startDate": "2021-10-08T00:00:00",
                "endDate": "2021-10-30T00:00:00",
                "isPublic": false,
                "competitors": [],
                "user": {
                    "id": 1,
                    "login": "testakk",
                    "email": null,
                    "password": null,
                    "subscription": null,
                    "sports": null
                },
                "streamUrl": null,
                "state": "planned",
                "timetableCells": null
            }
        ]*/

        // data приходит в виде массива с одним элементом - объектом с информацией
        if (data.length === 0) {
            return;
        }

        const info = data[0];
        if (!info) {
            return;
        }

        console.log(info);
        parseCompetitionInfo(info);
        parseCompetitorsList(info);
    }

    function parseCompetitionInfo(info) {
        document.querySelector(".competition-title").innerHTML = info.title;
        document.querySelector(".organizer").innerHTML = info.user.login;
        document.querySelector(".city").innerHTML = info.city;
        document.querySelector(".competition-description").innerHTML =
            info.description;
        document.querySelector(".competitors-number").innerHTML =
            info.competitors.length.toString();
        if(info.user.login != Cookies.get('login')){
            document.getElementById('edit_autor_show').remove();
        }
    }

    function parseCompetitorsList(info) {
        const competitorsTableBodyEl =
            document.querySelector(".competitors-table tbody");
        competitorsTableBodyEl.innerHTML = "";

        for (let competitor of info.competitors) {
            let tr = document.createElement("tr");
            tr.innerHTML =
                `<td>
                    <div class="td-content customer-name">
                        <img src="/assets/images/user-48.png" alt="avatar">
                        <span>${competitor.name}</span>
                    </div>
                </td>
                <td><div class="td-content product-brand text-primary">${competitor.age}</div></td>
                <td><div class="td-content"><span class="badge badge-primary">${competitor.team}</span></div></td>`;
            competitorsTableBodyEl.appendChild(tr);
        }
    }
}


function sendInvitation(email) {
    if (!email) {
        console.log("Bad email");
        return;
    }

    const requestUrl = "/api/post";

    // get competition id
    const competitionId = parseInt(getUrlVars().id);
    if (!competitionId) {
        console.log("Can`t define current competition id from url variables");
        console.log("So I can`t send request for invitation(");
        return;
    }

    // get user id
    const userId = Cookies.get("id");
    if (!userId) {
        console.log("Can`t get user id from Cookies");
        return;
    }

    const body = {
        competitionId: competitionId,
        userId: userId,
        email: email,
    }

    ServerRequest.send("POST", requestUrl, body)
      .then(data => console.log(data))
      .catch(err => console.log(err));
}


function generateTimetable() {
    const requestUrl = "/api/timetables/create";

    // get competition id
    const competitionId = parseInt(getUrlVars().id);
    if (!competitionId) {
        console.log("Can`t define current competition id from url variables");
        console.log("So I can`t send request for generating timetable(");
        return;
    }

    // test dates range
    const dateStart = new Date().toJSON().substr(0, 11) + "10:00:00";
    const dateEnd = new Date().toJSON().substr(0, 11) + "18:00:00";

    const body = {
        id: competitionId,
        start: dateStart,
        end: dateEnd,
    }

    ServerRequest.send("POST", requestUrl, body)
      .then(data => console.log(data))
      .catch(err => console.log(err));
}


function getTimetable() {
    // get competition id
    const competitionId = parseInt(getUrlVars().id);
    if (!competitionId) {
        console.log("Can`t define current competition id from url variables");
        console.log("So I can`t send request for generating timetable(");
        return;
    }

    const requestUrl = "/api/timetables/" + competitionId;

    ServerRequest.send("GET", requestUrl)
      .then(data => console.log(data))
      .catch(err => console.log(err));
}