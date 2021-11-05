const startCompetitionButtonEl = document.querySelector("#start_competitions");


document.addEventListener("DOMContentLoaded", pageLoaded);

function pageLoaded() {
    const competitionId = parseInt(getUrlVars().id);
    if (!competitionId) {
        return;
    }

    getCompetitionInfoFromServer(competitionId);
    //parseServerResponse([true]);

    function getCompetitionInfoFromServer(competitionId) {
        const requestParams = new RequestParams();
        requestParams.url = "/api/competitions/" + competitionId;

        ServerRequest.send(requestParams)
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
        if(info.state == 0 || info.state == "0"){
            document.querySelector(".state_sport").innerHTML = "Планування та набір";
        }
        if(info.state == 1 || info.state == "1"){
            document.querySelector(".state_sport").innerHTML = "Проводиться";
            document.getElementById('start_competitions').remove();
        }
        if(info.state == 2 || info.state == "2"){
            document.querySelector(".state_sport").innerHTML = "Завершено";
            document.getElementById('start_competitions').remove();
        }
        if(info.state != 0 && info.state != 1 && info.state != 2){
            document.querySelector(".state_sport").innerHTML = "Статус не визначено.";
        }
        document.querySelector(".competition-description").innerHTML =
            info.description;
        document.querySelector(".competitors-number").innerHTML =
            info.competitors.length.toString();
        if(info.user.login != Cookies.get('login')){
            document.getElementById('edit_autor_show').remove();
            document.getElementById('start_competitions').remove();
            if(info.isOpen == false){
                document.getElementById('send_add_player').remove();
            }
        }else{

        }

        // if teams number less than 2 - hide start competition button
        if (!info.competitors.length) {
            startCompetitionButtonEl.style.display = "none";
        } else {
            let teamsArr = [];
            for (let competitor of info.competitors) {
                const competitorTeam = competitor.team;
                let teamExist = false;
                for (let team of teamsArr) {
                    if (competitorTeam === team) {
                        teamExist = true;
                        break;
                    }
                }

                if (teamExist) {
                    continue;
                }

                teamsArr.push(competitorTeam);
            }

            if (teamsArr.length < 2) {
                startCompetitionButtonEl.style.display = "none";
            }
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

    const requestParams = new RequestParams("POST");
    requestParams.url = "/api/competitions/" + competitionId;
    requestParams.body = {
        competitionId: competitionId,
        userId: userId,
        email: email,
    }

    ServerRequest.send(requestParams)
      .then(data => console.log(data))
      .catch(err => console.log(err));
}


startCompetitionButtonEl.addEventListener("click", () => startCompetition());

function startCompetition() {
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

    const requestParams = new RequestParams("POST");
    requestParams.url = "/api/timetables/create";
    requestParams.body = {
        id: competitionId,
        start: dateStart,
        end: dateEnd,
    }

    ServerRequest.send(requestParams)
      .then(data => {
          console.log(data);
          pageLoaded();
      })
      .catch(err => {
          console.log(err);
          location.reload();
      });
}


function getTimetable() {
    // get competition id
    const competitionId = parseInt(getUrlVars().id);
    if (!competitionId) {
        console.log("Can`t define current competition id from url variables");
        console.log("So I can`t send request for generating timetable(");
        return;
    }

    const requestParams = new RequestParams();
    requestParams.url = "/api/timetables/" + competitionId;

    ServerRequest.send(requestParams)
      .then(data => console.log(data))
      .catch(err => console.log(err));
}

function send_togo() {
    const sendButtonEl = document.querySelector("#send");
    const openInputEl = document.querySelector("#open_input");
    const inputMailEl = document.querySelector("#input_mail");
    const joinEl = document.querySelector("#join");

    joinEl.style.display = "none";
    sendButtonEl.style.height = "36px";
    sendButtonEl.style.display = "inline";
    sendButtonEl.textContent = "Відправити";
    openInputEl.style.display = "none";
    inputMailEl.style.display = "block";

    // add ability to run request function by clicking send button
    sendButtonEl.addEventListener("click", () => {
        sendInvitation(inputMailEl.value);
        joinEl.style.display = "inline";
        sendButtonEl.style.display = "none";
        openInputEl.style.display = "inline";
        inputMailEl.style.display = "none";
        document.getElementById('done_info').style.display = 'block';
    });
}

function fixation(id){
    document.getElementById("modal_edit").style.display = "block";
    document.getElementById("name_t1_edit").textContent = document.getElementById("name_t1_" + id).textContent;
    document.getElementById("name_t2_edit").textContent = document.getElementById("name_t2_" + id).textContent;
    document.getElementById("result_t1_edit").value = document.getElementById("result_t1_" + id).textContent;
    document.getElementById("result_t2_edit").value = document.getElementById("result_t2_" + id).textContent;
    document.getElementById("save_edit").setAttribute("onclick", "save_edit_f(" + id + ")");
}

// ЗАПРОС НА СОХРАНЕНИЕ РЕЗУЛЬТАТА
function save_edit_f(id){
    document.getElementById("modal_edit").style.display = "none";
    document.getElementById("result_t1_" + id).textContent = document.getElementById("result_t1_edit").value;
    document.getElementById("result_t2_" + id).textContent = document.getElementById("result_t2_edit").value;
}

var id = getUrlVars()["id"];
if(getUrlVars()["id"] == undefined){
    //history.back();
}
var options = "none";
document.getElementById("join").href = "join/?game=" + id;
document.getElementById("grid_frame").src = "grid/?id=" + id + "&options=" + options;

if (devices.test(navigator.userAgent))
{ /* События для телефонов */  }
else{ document.getElementById("grid_frame").setAttribute("scrolling", "no"); }

function edit_shedule(){
    document.getElementById('main_apps').style.display = "none";
    document.getElementById('edit_autor').style.display = "none";
    document.getElementById('edit_shedule').style.display = "block";
    document.getElementById('show_main').style.display = "block";
    if(devices.test(navigator.userAgent)){
        document.getElementById("edit_shedule").scrollIntoView({block: "center", behavior: "smooth"});
    }
}

function show_main(){
    document.getElementById('main_apps').style.display = "block";
    document.getElementById('edit_autor').style.display = "block";
    document.getElementById('edit_shedule').style.display = "none";
    document.getElementById('show_main').style.display = "none";
}