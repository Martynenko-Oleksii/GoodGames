const loginInputEl = document.querySelector(".login-input");
const emailInputEl = document.querySelector(".email-input");
const oldPasswordInputEl = document.querySelector(".old-password-input");
const newPasswordInputEl = document.querySelector(".new-password-input");


function saveChanges() {
  const userId = Cookies.get("id");
  if (!userId) {
    console.log("Can`t get id from Cookies");
    return;
  }

  sendAvatarChangeServerRequest(userId);
  sendLoginChangeServerRequest();
  sendEmailChangeServerRequest();
}

function sendAvatarChangeServerRequest(userId) {
  const requestUrl = "/api/users/change/image/" + userId;

  const body = {

  }

  sendServerRequest(requestUrl, body);
}

function sendLoginChangeServerRequest() {
  const requestUrl = "/api/users/change/login";

  const body = {
    login: loginInputEl.value,
  }

  sendServerRequest(requestUrl, body);
}

function sendEmailChangeServerRequest() {
  const requestUrl = "/api/users/change/email";

  const body = {
    email: emailInputEl.value,
  }

  sendServerRequest(requestUrl, body);
}


function sendPasswordChangeRequest() {
  const requestUrl = "/api/users/change/password";

  const body = {
    oldPassword: oldPasswordInputEl.value,
    newPasswordInputEl: newPasswordInputEl.value,
  }

  sendServerRequest(requestUrl, body);
}



function sendServerRequest(requestUrl, body) {
  ServerRequest.send("POST", requestUrl, body)
    .then(data => {
      console.log("Server response from ", requestUrl, "request:");
      console.log(data);
    })
    .catch(err => console.log(err));
}