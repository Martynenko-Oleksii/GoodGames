const avatarEl = document.querySelector(".avatar");
const avatarInputEl = document.querySelector(".avatar-input");
const changeAvatarButtonEl = document.querySelector(".change-avatar-button");
const resetFileButtonEl = document.querySelector(".reset-file-button");
const loginInputEl = document.querySelector(".login-input");
const emailInputEl = document.querySelector(".email-input");
const changeProfileInfoButtonEl =
  document.querySelector(".change-profile-info-button");
const passwordInputEl = document.querySelector(".password-input");
const changePasswordButtonEl =
  document.querySelector(".change-password-button")


document.addEventListener("DOMContentLoaded", pageLoaded);

function pageLoaded() {
  updateAvatarInterface();

  const oldLogin = Cookies.get("login");
  const oldEmail = Cookies.get("email");

  loginInputEl.value = oldLogin;
  emailInputEl.value = oldEmail;
}

function updateAvatarInterface() {
  const userId = Cookies.get("id");
  if (!userId) {
    console.log("Can`t get id from Cookies");
    return;
  }

  const requestParams = new RequestParams();
  requestParams.url = "/api/users/" + userId;

  ServerRequest.send(requestParams)
    .then(data => {
      const avatarPath = data.avatarPath;

      if (avatarPath) {
        changeAvatarButtonEl.innerHTML = "Змінити аватар";
        avatarEl.src = avatarPath;
        resetFileButtonEl.style.display = "inline-block";
        return;
      }

      changeAvatarButtonEl.innerHTML = "Додати аватар";
      avatarEl.src = "/assets/images/user-48.png";
      resetFileButtonEl.style.display = "none";
    })
    .catch(err => console.log(err));
}


changeProfileInfoButtonEl.addEventListener("click", () => changeProfileInfo());

function changeProfileInfo() {
  const userId = Cookies.get("id");
  if (!userId) {
    console.log("Can`t get id from Cookies");
    return;
  }


  sendAvatarChangeRequest();
  sendLoginChangeRequest();
  sendEmailChangeRequest();


  function sendAvatarChangeRequest() {
    let file = avatarInputEl.files[0];

    if (!file) {
      return;
    }

    let formData = new FormData();
    formData.append("image", file);

    const requestParams = new RequestParams("POST");
    requestParams.url = "/api/users/change/image/" + userId;
    requestParams.body = formData;
    requestParams.responseType = "text";
    requestParams.contentType = "";
    requestParams.stringify = false;

    ServerRequest.send(requestParams)
      .then(data => changeLocalAvatar())
      .catch(err => console.log(err));
  }

  function sendLoginChangeRequest() {
    if (loginInputEl.value === Cookies.get("login")) {
      return;
    }

    const requestParams = new RequestParams("POST");
    requestParams.url = "/api/users/change/login";
    requestParams.body = {
      id: userId,
      login: loginInputEl.value,
    }

    ServerRequest.send(requestParams)
      .then(data => changeLocalLogin(data.login))
      .catch(err => console.log(err));
  }

  function sendEmailChangeRequest() {
    if (emailInputEl.value === Cookies.get("email")) {
      return;
    }

    const requestParams = new RequestParams("POST");
    requestParams.url = "/api/users/change/email";
    requestParams.body = {
      id: userId,
      email: emailInputEl.value,
    }

    ServerRequest.send(requestParams)
      .then(data => changeLocalEmail(data.email))
      .catch(err => console.log(err));
  }


  function changeLocalLogin(newLogin) {
    Cookies.set("login", newLogin);
    alert("Логін успішно змінено");
  }

  function changeLocalEmail(newEmail) {
    Cookies.set("email", newEmail);
    alert("Пошту успішно змінено");
  }

  function changeLocalAvatar() {
    alert("Аватар успішно змінено");
  }
}


changePasswordButtonEl.addEventListener("click", () => changePassword());

function changePassword() {
  const userId = Cookies.get("id");
  if (!userId) {
    console.log("Can`t get id from Cookies");
    return;
  }

  sendPasswordChangeRequest();

  function sendPasswordChangeRequest() {
    if (!passwordInputEl.value) {
      return;
    }

    const requestParams = new RequestParams("POST");
    requestParams.url = "/api/users/change/password";
    requestParams.body = {
      id: userId,
      password: passwordInputEl.value,
    }

    ServerRequest.send(requestParams)
      .then(data => getPasswordChangeResponse())
      .catch(err => console.log(err));
  }

  function getPasswordChangeResponse() {
    alert("Пароль успішно змінено");
  }
}