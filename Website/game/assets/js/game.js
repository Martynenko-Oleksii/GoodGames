const startCompetitionButtonEl = document.querySelector("#start_competitions");
const stateSportEl = document.querySelector(".state_sport");
const competitionTitleEl = document.querySelector(".competition-title");
const competitionDescriptionEl =
  document.querySelector(".competition-description");
const organizerEl = document.querySelector(".organizer");
const cityEl = document.querySelector(".city");
const competitorsNumberEl =
  document.querySelector(".competitors-number");
const startCompetitionsEl = document.querySelector("#start_competitions");
const sendAddPlayerEl = document.querySelector("#send_add_player");
const openInputEl = document.querySelector("#open_input");
const joinEl = document.querySelector("#join");

const nameT1EditEl = document.querySelector("#name_t1_edit");
const nameT2EditEl = document.querySelector("#name_t2_edit");
const resultT1EditEl = document.querySelector("#result_t1_edit");
const resultT2EditEl = document.querySelector("#result_t2_edit");

const translationInputEl = document.querySelector(".translation-input");

let isopen;
let competitionId;
let competitionUserId;

let organizator;
let setadmin = false;
let stardDate;
let endDate;

document.addEventListener("DOMContentLoaded", pageLoaded);

function pageLoaded() {
  competitionId = parseInt(getUrlVars().id);
  if (!competitionId) {
    return;
  }

  updateCompetitionGeneralInfo();
}

function updateCompetitionGeneralInfo() {

  let id = getUrlVars()["id"];
  if (!getUrlVars()["id"]) {
    history.back();
  }
  let options = "none";
  document.getElementById("join").href = "join/?game=" + id;
  document.getElementById("grid_frame").src = "grid/?id=" + id + "&options=" + options;
  document.getElementById("grid_frame_full").src = "grid/?id=" + id + "&options=" + options;

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
      history.back();
      return;
    }

    const info = data[0];
    if (!info) {
      history.back();
      return;
    }

    console.log(info);
    competitionUserId = info.user.id;
    stardDate = info.startDate;
    endDate = info.endDate;

    parseCompetitionInfo(info);
    parseCompetitorsList(info);

    updateCompetitionTimetable();
    createListAdmins();
  }

  function parseCompetitionInfo(info) {
    competitionTitleEl.innerHTML = info.title;
    organizerEl.innerHTML = info.user.login;
    organizator = info.user.login;
    cityEl.innerHTML = info.city;
    competitionDescriptionEl.innerHTML = info.description;
    competitorsNumberEl.innerHTML = info.competitors.length.toString();

    isopen = info.isOpen;

    info.state = parseInt(info.state);
    switch (info.state) {
      case 0:
        stateSportEl.innerHTML = "Планування та набір";
        break;
      case 1:
        stateSportEl.innerHTML = "Проводиться";
        startCompetitionButtonEl.style.display = "none";
        openInputEl.style.display = "none";
        joinEl.style.display = "none";
        break;
      case 2:
        stateSportEl.innerHTML = "Завершено";
        startCompetitionButtonEl.style.display = "none";
        openInputEl.style.display = "none";
        joinEl.style.display = "none";
        break;
      default:
        stateSportEl.innerHTML = "Статус не визначено.";
    }

    if(info.streamUrl != null){
      document.getElementById('live_stream_link').href = "stream/?id=" + competitionId;
    }else{
      document.getElementById('live_stream_link').style.display = "none";
    }

    // if teams number less than 2 - hide start competition button
    const teamArray = getTeamArrayByCompetitorArray(info.competitors);

    if (teamArray.length < 2) {
      startCompetitionButtonEl.remove();
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
                <img src="/assets/images/user-game.png" alt="avatar">
                <span>${competitor.name}</span>
            </div>
        </td>
        <td><div class="td-content product-brand text-primary">${competitor.age}</div></td>
        <td><div class="td-content"><span class="badge badge-primary">${competitor.team}</span></div></td>`;

        competitor.gender = competitor.gender === "m" ? "Чоловіча" : "Жіноча";

        if (competitor.healthState.toString() === "0") {
          competitor.healthState = "Не вказано";
        }
      
        const ageLastDigit = competitor.age % 10;
        if (ageLastDigit === 1) {
          competitor.age += " рік";
        } else if (ageLastDigit === 0 || ageLastDigit > 4) {
          competitor.age += " років";
        } else {
          competitor.age += " роки";
        }
      
        competitor.weigth += "кг";
        
        tr.onclick = function () {
          // Передача информации в окно информации
          modal_user_about_show(competitor);
      };
      competitorsTableBodyEl.appendChild(tr);
    }
  }
}

function createListAdmins() {
  sendServerRequest();

  function sendServerRequest() {
    const requestParams = new RequestParams();
    requestParams.url = "/api/admins/" + competitionId;

    ServerRequest.send(requestParams)
      .then(data => parseServerResponse(data))
      .catch(err => console.log(err));
  }

  function parseServerResponse(data) {
    if (!data || !data.length) {
      return;
    }

    admin_rule(data);
    parseAdminList(data);

    function parseAdminList(info) {
      const AdminTableBodyEl =
        document.querySelector(".admin-table tbody");
        AdminTableBodyEl.innerHTML = "";

      for (let user of info){
        let role = "Модератор";
        if(organizator == user.login){ role = "Організатор"}

        let avatars = "/assets/images/user-48.png";
        if(user.avatarPath != null){
          avatars = user.avatarPath;
        }

        let tr = document.createElement("tr");
        tr.setAttribute("id", "admin_list_" + user.id);
        if (setadmin) {
          if(role == "Модератор"){
            tr.innerHTML =
            `<td><div class="td-content product-name">
                <img src="${avatars}" alt="product"><div class="align-self-center">
                    <p class="prd-name">${user.login}</p>
                    <p class="prd-category text-primary">Модератор</p>
                </div></div>
              </td>
              <td><div class="td-content">${user.id}</div></td>
              <td><a onclick="del_admin(${user.id});" class="btn btn-outline-danger btn-sm">Виключити</a></td>`;
          }else{
            tr.innerHTML =
            `<td><div class="td-content product-name">
                <img src="${avatars}" alt="product"><div class="align-self-center">
                    <p class="prd-name">${user.login}</p>
                    <p class="prd-category text-primary">Організатор</p>
                </div></div>
              </td>
              <td><div class="td-content">${user.id}</div></td>
              <td><a>- - -</a></td>`;
          }
        }else{
          tr.innerHTML =
          `<td><div class="td-content product-name">
              <img src="${avatars}" alt="product"><div class="align-self-center">
                  <p class="prd-name">${user.login}</p>
                  <p class="prd-category text-primary">${role}</p>
              </div></div>
            </td>
            <td><div class="td-content">${user.id}</div></td>
            <td><a>- - -</a></td>`;
        }
        AdminTableBodyEl.appendChild(tr);
      }
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

    try {
      document.querySelector("#empty_match").style.display = "none";
    } catch (e) {
      console.log("Обновление таблицы...");
    }

    const userId = parseInt( Cookies.get("id") );

    const TimeTableBodyEl = document.querySelector(".generate_shedule");

    for (let timetableBlockInfo of data) {
      const timetableCellId = timetableBlockInfo.id;
      const date = new Date(timetableBlockInfo.dateTime);
      const dateString = date.toLocaleDateString();
      const timeString = date.toLocaleTimeString();
      const teamsArray =
        getTeamArrayByCompetitorArray(timetableBlockInfo.competitors);

      let team1Result = 0;
      let team2Result = 0;
      if (timetableBlockInfo.winResult) {
        const score = timetableBlockInfo.winResult.score;
        let regex = /\d+/g;
        team1Result = regex.exec(score)[0];
        team2Result = regex.exec(score)[0];
      }

      let fixResultsEl = "";
      if (userId && competitionUserId && userId === competitionUserId) {
        fixResultsEl =
          `<a class="btn btn-outline-info btn-sm"
            id="edit_autor_show"
            onclick="openFixationModalWindow(${timetableCellId});">
            Фіксація результатів
          </a>`;
      }

      TimeTableBodyEl.innerHTML +=
        `<div class="widget widget-four" style="margin-bottom: 20px;" id="timetableCell-${timetableCellId}">
          <div class="widget-heading">
            <h5 class="">${dateString} ${timeString}</h5>
            ${fixResultsEl}
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
                      <h6>Команда <span class="summary-count team1-name">${teamsArray[0]}</span></h6>
                      <p class="summary-average">
                        <a class="card team1-result" style="padding: 0.75rem; margin-top: 0;">${team1Result}</a>
                      </p>
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
                      <p class="summary-average">
                        <a class="card team2-result" style="padding: 0.75rem; margin-top: 0;">${team2Result}</a>
                      </p>
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
  document.getElementById("error_start_comp").style.display = "none";

  // get competition id
  const competitionId = parseInt(getUrlVars().id);
  if (!competitionId) {
    console.log("Can`t define current competition id from url variables");
    console.log("So I can`t send request for generating timetable(");
    return;
  }
  
  /*
  const dateStart = new Date().toJSON().substr(0, 11) + " 10:00:00";
  let dateEnd = new Date();
  dateEnd.setDate(dateEnd.getDate() + 7);
  dateEnd = dateEnd.toJSON().substr(0, 11) + " 18:00:00";
  */ 

  let dateStart = stardDate.replace("00:00:00", "10:00:00");
  let dateEnd = endDate.replace("00:00:00", "21:00:00");

  const requestParams = new RequestParams("POST");
  requestParams.url = "/api/timetables/create";
  requestParams.body = {
    id: competitionId,
    start: dateStart,
    end: dateEnd,
  }
  requestParams.responseType = 'text';

  ServerRequest.send(requestParams)
    .then(data => {
      console.log(data);
      pageLoaded();
    })
    .catch(err => {
      //console.log(err);
      document.getElementById("error_start_comp").style.display = "block";
      document.getElementById("error_start_comp").textContent = err;
    });
}


function openFixationModalWindow(timetableCellId) {
  document.getElementById("error_edit_res").style.display = "none";
  console.log(timetableCellId)
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

  const team1Name = team1NameEl.textContent;
  const team2Name = team2NameEl.textContent;

  nameT1EditEl.textContent = team1Name;
  nameT2EditEl.textContent = team2Name;
  resultT1EditEl.value = team1ResultEl.textContent;
  resultT2EditEl.value = team2ResultEl.textContent;

  const fixResultButtonEl = document.querySelector(".fix-results-button");
  const fixResultFunction = `fixResults(${timetableCellId}, '${team1Name}', '${team2Name}')`;
  fixResultButtonEl.setAttribute('onclick', fixResultFunction);
}

function fixResults(timetableCellId, team1Name, team2Name) {
  console.log(timetableCellId)
  const team1Result = document.querySelector("#result_t1_edit").value;
  const team2Result = document.querySelector("#result_t2_edit").value;
  
  if(team1Result < 0){
    document.getElementById("error_edit_res").style.display = "block";
    document.getElementById("error_edit_res").textContent = "Вкажіть переможця";
    return;
  }

  if(team2Result < 0){
    document.getElementById("error_edit_res").style.display = "block";
    document.getElementById("error_edit_res").textContent = "Негативні значення";
    return;
  }

  if(team1Result == team2Result){
    document.getElementById("error_edit_res").style.display = "block";
    document.getElementById("error_edit_res").textContent = "Негативні значення";
    return;
  }

  document.querySelector("#modal_edit").style.display = "none";
  sendServerRequest();

  function sendServerRequest() {
    const requestParams = new RequestParams("POST");
    requestParams.url = "/api/results";
    requestParams.body = {
      id: timetableCellId,
      teamOne: team1Name,
      teamTwo: team2Name,
      score: team1Result + "," + team2Result,
    }

    ServerRequest.send(requestParams)
      .then(() => updateDom())
      .catch(err => console.log(err));
  }

  function updateDom() {
    const team1ResultElSelector = `#timetableCell-${timetableCellId} .team1-result`;
    const team2ResultElSelector = `#timetableCell-${timetableCellId} .team2-result`;
    document.querySelector(team1ResultElSelector).textContent = resultT1EditEl.value;
    document.querySelector(team2ResultElSelector).textContent = resultT2EditEl.value;
    $('.generate_shedule').empty();
    updateCompetitionGeneralInfo();
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

if (devices.test(navigator.userAgent))
{ /* События для телефонов */  }
else {
  document.getElementById("grid_frame").setAttribute("scrolling", "no");
}

function edit_shedule() {
  document.getElementById('main_apps').style.display = "none";
  document.getElementById('edit_autor').style.display = "none";
  document.getElementById('edit_shedule').style.display = "block";
  document.getElementById('show_main').style.display = "block";
  if(devices.test(navigator.userAgent)) {
    document.getElementById("edit_shedule").scrollIntoView({block: "center", behavior: "smooth"});
  }
}

function show_main() {
  document.getElementById('main_apps').style.display = "block";
  document.getElementById('edit_autor').style.display = "block";
  document.getElementById('edit_shedule').style.display = "none";
  document.getElementById('show_main').style.display = "none";
}

function del_admin(id){ //Удаление администратора
    if(setadmin){
      const requestParams = new RequestParams("POST");
      requestParams.url = "/api/competitions/deleteadmin/" + competitionId;
      requestParams.body = {
        id: id,
    }

      ServerRequest.send(requestParams)
        .then(data => document.getElementById('admin_list_' + id).remove())
        .catch(err => console.log(err));
    }else{
      return;
    }
}

function add_admin(){
  if(setadmin){
    const requestParams = new RequestParams("POST");
    requestParams.url = "/api/competitions/addadmin/" + competitionId;
    requestParams.body = {
      email: document.getElementById('admin_email').value,
    }

    ServerRequest.send(requestParams)
      .then(data => location.reload())
      .catch(err => console.log(err));
  }else{
    return;
  }
}

function add_live() {
  const requestParams = new RequestParams("POST");
  requestParams.url = "/api/competitions/addstream";
  requestParams.body = {
    id: competitionId,
    streamUrl: translationInputEl.value,
  }

  ServerRequest.send(requestParams)
    .then(data => console.log(data))
    .catch(err => console.log(err));

  closeTranslationModalWindow();
}

function closeTranslationModalWindow() {
  document.querySelector("#modal-window_admin").style.display = "none";
}

function ADD_ADMIN_SU(){
  document.getElementById('modal-window_admin').style.display = 'block';
  document.getElementById('setadmin').style.display = 'block';
  document.getElementById('setlive').style.display = 'none';
}

function ADD_LIVE_SU(){
  document.getElementById('modal-window_admin').style.display = 'block';
  document.getElementById('setadmin').style.display = 'none';
  document.getElementById('setlive').style.display = 'block';
}

function admin_rule(adminslist){
  const userId = Cookies.get("id");

  for(let admin of adminslist){
    if(userId == admin.id){
      setadmin = true;
      console.log("Администатор включен");
      return;
    }
  }

  if (setadmin == false) {
    startCompetitionsEl.remove();
    document.getElementById('adminpanel').remove();
    if (!isopen) {
      sendAddPlayerEl.remove();
    }
  }
}

function modal_user_about_show(competitor) {
  document.querySelector("#modal_user_game").style.display = "block";
  changeElementTextContent("#ABOUT_USER_NAME", competitor.name);
  changeElementTextContent("#ABOUT_USER_TEAM", competitor.team);
  changeElementTextContent("#ABOUT_USER_GENDER", competitor.gender);
  changeElementTextContent("#ABOUT_USER_HEALTH", competitor.healthState);
  changeElementTextContent("#ABOUT_USER_AGE", competitor.age);
  changeElementTextContent("#ABOUT_USER_WEIGTH", competitor.weigth);

  function changeElementTextContent(elementSelector, newTextContent) {
    document.querySelector(elementSelector).textContent = newTextContent;
  }
}

/*

    const requestParams = new RequestParams();
    requestParams.url = "/api/competitions/" + competitionId;

    ServerRequest.send(requestParams)
      .then(data => console.log(data[0].competitors[0].name))
      .catch(err => console.log(err));

*/



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