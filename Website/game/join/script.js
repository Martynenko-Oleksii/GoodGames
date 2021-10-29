/*! =========================================================
 * =========================================================
 *
 *                       _oo0oo_
 *                      o8888888o
 *                      88" . "88
 *                      (| -_- |)
 *                      0\  =  /0
 *                    ___/`---'\___
 *                  .' \|     |// '.
 *                 / \|||  :  |||// \
 *                / _||||| -:- |||||- \
 *               |   | \\  -  /// |   |
 *               | \_|  ''\---/''  |_/ |
 *               \  .-\__  '-'  ___/-. /
 *             ___'. .'  /--.--\  `. .'___
 *          ."" '<  `.___\_<|>_/___.' >' "".
 *         | | :  `- \`.;`\ _ /`;.`/ - ` : | |
 *         \  \ `_.   \_ __\ /__ _/   .-` /  /
 *     =====`-.____`.___ \_____/___.-`___.-'=====
 *                       `=---='
 *
 *     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~s
 *
 *               Будда говорит:  "Нет багов!"
 *
 * ========================================================= */

const form = document.querySelector("form"),
statusTxt = form.querySelector(".button-area span");

document.addEventListener("DOMContentLoaded", insertCompetitionInfo);

function insertCompetitionInfo() {
  sendRequest();

  function sendRequest() {
    // get competition id
    const competitionId = parseInt(getUrlVars().game);
    if (!competitionId) {
      console.log("Can`t define current competition id from url variables");
      console.log("So I can`t send request for invitation(");
      return;
    }

    const requestUrl = "/api/competitions/" + competitionId;

    ServerRequest.send("GET", requestUrl)
      .then(data => parseResponse(data))
      .catch(err => console.log(err));
  }

  function parseResponse(data) {
    if (!data || data.length === 0 || !data[0]) {
      console.log("bad data");
      console.log("so I can`t insert competition title");
      return;
    }

    document.querySelector(".competition-title").innerHTML = data[0].title;
  }
}

//email
// ? document.getElementById("email").value = Cookie.get('email');

function getUrlVars() {
  var vars = {};
  var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
      vars[key] = value;
  });
  return vars;
}

var id = getUrlVars()["id"]; // Идентификатор пользователя
var game = getUrlVars()["game"]; // Идентификатор соревнования

function sendjoin(){
  statusTxt.style.color = "#0D6EFD";
  statusTxt.style.display = "block";
  statusTxt.innerText = "Реєструємо вас...";
  form.classList.add("disabled");

  const requestUrl = "/api/competitors";

  const genderInputValue = document.querySelector("#gender").value;
  const genderChar = (genderInputValue === "жінка") ? "f" : "m";

  const body = {
    team: document.querySelector("#team").value,
    name: document.querySelector("#name").value,
    email: document.querySelector("#email").value,
    age: document.querySelector("#age").value,
    weigth: document.querySelector("#weigth").value,
    gender: genderChar,
    healthState: document.querySelector("#healthstate").value,
    competitions: [ {id: getUrlVars()["game"]} ],
  }

  ServerRequest.send("POST", requestUrl, body)
    .then(data => console.log(data))
    .catch(err => console.log(err));
}