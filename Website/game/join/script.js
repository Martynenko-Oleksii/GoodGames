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

  // Запрос...
  const requestUrl = "/api/";


  const team = document.querySelector("#team").value;
  const name = document.querySelector("#name").value;
  const email = document.querySelector("#email").value;
  const age = document.querySelector("#age").value;
  const weigth = document.querySelector("#weigth").value;
  const gender = document.querySelector("#gender").value;
  const healthstate = document.querySelector("#healthstate").value;
  const competitions = getUrlVars()["game"];

  const userId = game;
    if (!userId) {
        console.log("Соревнования нет.");
        //return;
    }

  alert(team + "\n" + name + "\n" + email + "\n" + age + "\n" + weigth + "\n" +gender + "\n" +healthstate);
}