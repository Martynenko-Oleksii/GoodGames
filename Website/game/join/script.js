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

form.onsubmit = (e)=>{
  e.preventDefault();
  statusTxt.style.color = "#0D6EFD";
  statusTxt.style.display = "block";
  statusTxt.innerText = "Реєструємо вас...";
  form.classList.add("disabled");

  // Запрос...
  
}