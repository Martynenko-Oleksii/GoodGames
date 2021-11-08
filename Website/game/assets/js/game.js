const startCompetitionButtonEl = document.querySelector("#start_competitions");
const nameT1EditEl = document.querySelector("#name_t1_edit");
const nameT2EditEl = document.querySelector("#name_t2_edit");
const resultT1EditEl = document.querySelector("#result_t1_edit");
const resultT2EditEl = document.querySelector("#result_t2_edit");

let competitionId;


document.addEventListener("DOMContentLoaded", pageLoaded);

function pageLoaded() {
  competitionId = parseInt(getUrlVars().id);
  if (!competitionId) {
    return;
  }

  updateCompetitionGeneralInfo();
  updateCompetitionTimetable();
}

function updateCompetitionGeneralInfo() {
  sendServerRequest();

  function sendServerRequest() {
    const requestParams = new RequestParams();
    requestParams.url = "/api/competitions/" + competitionId;

    ServerRequest.send(requestParams)
      .then(data => parseServerResponse(data))
      .catch(err => console.log(err));
  }

  function parseServerResponse(data) {
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
    info.state = parseInt(info.state);
    if (info.state === 0) {
      document.querySelector(".state_sport").innerHTML = "Планування та набір";
    } else if (info.state === 1) {
      document.querySelector(".state_sport").innerHTML = "Проводиться";
      document.getElementById('start_competitions').remove();
    } else if (info.state === 2) {
      document.querySelector(".state_sport").innerHTML = "Завершено";
      document.getElementById('start_competitions').remove();
    } else if (info.state !== 0 && info.state !== 1 && info.state !== 2) {
      document.querySelector(".state_sport").innerHTML = "Статус не визначено.";
    }
    document.querySelector(".competition-description").innerHTML =
      info.description;
    document.querySelector(".competitors-number").innerHTML =
      info.competitors.length.toString();
    if ( info.user.id.toString() !== Cookies.get('id') ) {
      document.getElementById('edit_autor_show').remove();
      document.getElementById('start_competitions').remove();
      if (!info.isOpen) {
        document.getElementById('send_add_player').remove();
      }
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

function updateCompetitionTimetable() {
  sendServerRequest();

  function sendServerRequest() {
    const requestParams = new RequestParams();
    requestParams.url = "/api/timetables/" + competitionId;

    ServerRequest.send(requestParams)
      .then(data => parseServerResponse(data))
      .catch(err => console.log(err));
  }

  function parseServerResponse(data) {
    if (!data || !data.length) {
      return;
    }

    console.log(data);

    document.querySelector("#empty_match").remove();

    const TimeTableBodyEl = document.querySelector(".generate_shedule");

    for (let timetableBlockInfo of data) {
      const date = new Date(timetableBlockInfo.date);
      const dateString = date.toLocaleDateString();
      const timeString = date.toLocaleTimeString();
      const teamsArray =
        getTeamArrayByCompetitorArray(timetableBlockInfo.competitors);
      const timetableCellId = timetableBlockInfo.id;

      TimeTableBodyEl.innerHTML +=
        `<div class="widget widget-four" style="margin-bottom: 20px;" id="timetableCell-${timetableCellId}">
          <div class="widget-heading">
            <h5 class="">${dateString} ${timeString}</h5>
            <a class="btn btn-outline-info btn-sm" id="edit_autor_show" onclick="openFixationModalWindow(${timetableCellId});">Фіксація результатів</a>
          </div>

          <div class="widget-content">
            <div class="order-summary">
              <div class="summary-list summary-income">
                <div class="summery-info">
                  <div class="w-icon">
                    <ion-icon name="people-circle-outline"></ion-icon>
                  </div>
                  <div class="w-summary-details">
                    <div class="w-summary-info">
                      <h6>Команда <span class="summary-count team2-name">${teamsArray[0]}</span></h6>
                      <p class="summary-average"><a class="card team1-result" style="padding: 0.75rem; margin-top: 0px;">0</a></p>
                    </div>
                  </div>
                </div>
              </div>

              <div class="summary-list summary-expenses">
                <div class="summery-info">
                  <div class="w-icon">
                    <ion-icon name="people-circle-outline"></ion-icon>
                  </div>
                  <div class="w-summary-details">
                    <div class="w-summary-info">
                      <h6>Команда <span class="summary-count team2-name">${teamsArray[1]}</span></h6>
                      <p class="summary-average"><a class="card team2-result" style="padding: 0.75rem; margin-top: 0px;">0</a></p>
                    </div>
                  </div>
                </div>
              </div>

            </div>
          </div>
        </div>`;
    }
  }
}

function getTeamArrayByCompetitorArray(competitorArray) {
  let teamsArray = [];

  for (let competitor of competitorArray) {
    const currentCompetitorTeam = competitor.team;

    let currentCompetitorTeamExists = false;
    for (let team of teamsArray) {
      if (team === currentCompetitorTeam) {
        currentCompetitorTeamExists = true;
        break;
      }
    }

    if (!currentCompetitorTeamExists) {
      teamsArray.push(currentCompetitorTeam);
    }
  }

  return teamsArray;
}


function sendInvitation(email) {
  if (!email) {
    console.log("Bad email");
    return;
  }

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
  requestParams.url = "/api/post";
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
      //location.reload();
    });
}


function openFixationModalWindow(timetableCellId) {
  document.querySelector("#modal_edit").style.display = "block";

  const timetableCellSelector = "#timetableCell-" + timetableCellId;

  const team1NameEl =
    document.querySelector(timetableCellSelector + " .team1-name");
  const team2NameEl =
    document.querySelector(timetableCellSelector + " .team2-name");
  const team1ResultEl =
    document.querySelector(timetableCellSelector + " .team1-result");
  const team2ResultEl =
    document.querySelector(timetableCellSelector + " .team2-result");

  nameT1EditEl.textContent = team1NameEl.textContent;
  nameT2EditEl.textContent = team2NameEl.textContent;
  resultT1EditEl.value = team1ResultEl.textContent;
  resultT2EditEl.value = team2ResultEl.textContent;

  document.querySelector("#save_edit").onclick = `fixResults( ${timetableCellId} )`;
}

function fixResults(timetableCellId) {
  const team1Result = document.querySelector("#result_t1_edit").value;
  const team2Result = document.querySelector("#result_t2_edit").value;

  updateDom();


  function updateDom() {
    document.querySelector("#modal_edit").style.display = "none";
    const team1ResultElSelector = `#timetableCell-${timetableCellId} .team1-result`;
    const team2ResultElSelector = `#timetableCell-${timetableCellId} .team2-result`;
    document.getElementById(team1ResultElSelector).textContent = document.getElementById("result_t1_edit").value;
    document.getElementById(team2ResultElSelector).textContent = document.getElementById("result_t2_edit").value;
  }

  function sendServerRequest() {
    const requestParams = new RequestParams("POST");
    requestParams.url = "/api/results";
    requestParams.body = {
      id: timetableCellId,
      teamOne: "title",
      teamTwo: "title",
      score: team1Result + "," + team2Result,
    }

    ServerRequest.send(requestParams)
      .then(data => console.log(data))
      .catch(err => console.log(err));
  }
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




/*
TEST DATA 1

{
    "id": 1,
    "title": "Турнир CS:Go",
    "description": "Тестирование соренвования.",
    "isOpen": false,
    "sport": null,
    "ageLimit": "8",
    "city": "Харків",
    "startDate": "2022-02-01T00:00:00",
    "endDate": "2022-02-04T00:00:00",
    "isPublic": true,
    "competitors": [
        {
            "id": 1,
            "name": "1",
            "email": "gg1@gg.com",
            "age": 18,
            "gender": "m",
            "weigth": 12,
            "healthState": "Відмінне",
            "team": "1"
        },
        {
            "id": 2,
            "name": "2",
            "email": "gg2@gg.com",
            "age": 2,
            "gender": "m",
            "weigth": 2,
            "healthState": "Відмінне",
            "team": "2"
        },
        {
            "id": 3,
            "name": "3",
            "email": "gg3@gg.com",
            "age": 3,
            "gender": "m",
            "weigth": 3,
            "healthState": "Відмінне",
            "team": "3"
        },
        {
            "id": 4,
            "name": "4",
            "email": "gg4@gg.com",
            "age": 4,
            "gender": "m",
            "weigth": 4,
            "healthState": "Відмінне",
            "team": "4"
        },
        {
            "id": 5,
            "name": "5",
            "email": "gg5@gg.com",
            "age": 5,
            "gender": "m",
            "weigth": 5,
            "healthState": "Відмінне",
            "team": "5"
        }
    ],
    "user": {
        "id": 1,
        "avatarPath": "/avatars/Avatar.png",
        "login": "Stamir",
        "email": "stasik1214x5@gmail.com",
        "password": "stas1214",
        "subscription": null,
        "sports": null,
        "token": null
    },
    "streamUrl": null,
    "state": 0,
    "timetableCells": null
}

*/

/*
TEST DATA 2


*/